//
//  ViewModel.swift
//  Car_Classifier
//
//  Created by Sy Lee on 2023/05/10.
//

import SwiftUI
import PhotosUI
import CoreML
import Vision

class ViewModel: ObservableObject {
    
    @Published var confidence: String = ""
    @Published var title: String = ""
    @Published var selectedPhoto: PhotosPickerItem? = nil
    @Published var selectedImageData: Data? = nil
    
    func detect(ciImg: CIImage) {
        let config = MLModelConfiguration()
        guard let model = try? CarClassifier_8(configuration: config).model else {
            fatalError("CarClassifier8 가져오기 오류 발생")
        }
        guard let vnCoreModel = try? VNCoreMLModel(for: model) else {
            fatalError("Vison Model 로 변형시 오류 발생")
        }
        
        let vnCoreMLRequest = VNCoreMLRequest(model: vnCoreModel) { request, error in
            let results = request.results as? [VNClassificationObservation]
            print("검색 결과: \(String(describing: results))")
            
            guard let topResult = results?.first else {
                fatalError("모스트 검색결과가 없습니다.")
            }
            self.confidence = "\(topResult.confidence.binade * 100)% "
            self.title = topResult.identifier.capitalized
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImg)
        do {
            try handler.perform([vnCoreMLRequest])
        } catch {
            print("비전 요청 핸들러 오류 발생")
        }
    } // detect()
    
    func dataToCIImage(data: Data) -> CIImage {
        guard let ciImage = CIImage(data: data) else {
            fatalError("Data -> CIImage 변환 실패")
        }
        return ciImage
    }
    
    
}

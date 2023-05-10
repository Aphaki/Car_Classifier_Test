//
//  ContentView.swift
//  Car_Classifier
//
//  Created by Sy Lee on 2023/05/10.
//

import SwiftUI
import CoreML
import Vision
import PhotosUI

struct ContentView: View {
    
    @StateObject var vm = ViewModel()
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $vm.selectedPhoto, matching: .images, photoLibrary: .shared()) {
                Text("Select a photo")
            }
            .onChange(of: vm.selectedPhoto) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        vm.selectedImageData = data
                        let ciImg = vm.dataToCIImage(data: data)
                        vm.detect(ciImg: ciImg)
                    }
                }
            }
            if let selectedImageData = vm.selectedImageData,
               let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
            Spacer()
            if vm.title != "" {
                HStack {
                    Text(vm.confidence)
                    Text(vm.title)
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

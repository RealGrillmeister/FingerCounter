//
//  ContentView.swift
//  FingerCounter
//
//  Created by Rickard Juldorf on 2024-11-17.
//

import SwiftUI
import PhotosUI
import CoreML
import Vision

struct ContentView: View {
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var image: Image?
    @StateObject var interpretImage = InterpretImage()
    
    var body: some View {
        VStack {
            HStack {
                Text(interpretImage.resultText)
            
                Text(interpretImage.probability)
            }
            
            image?
                                .resizable()
                                .scaledToFit()
            
            PhotosPicker(selection: $selectedPhoto) {
                                Text("Välj bild")
                            }
            
        }
        .onChange(of: selectedPhoto) { newValue in
                    Task {
                        if let data = try? await selectedPhoto?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            DispatchQueue.main.async {
                                image = Image(uiImage: uiImage)
                            }
                            interpretImage.interpretImage(theimageIn: uiImage)
                        } else {
                            print("❌ Kunde inte ladda bilden")
                        }
                    }
                }
    }
}

#Preview {
    ContentView()
}
 

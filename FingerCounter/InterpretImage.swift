//
//  InterpretImage.swift
//  FingerCounter
//
//  Created by Rickard Juldorf on 2024-11-17.
//

import Vision
import Foundation
import UIKit
import SwiftUI

class InterpretImage : ObservableObject {
    
    @Published var resultText = ""
    @Published var probability = ""
    @Published var outimg : UIImage?
    
    func interpretImage(theimageIn : UIImage) {
        processImage(theimage: theimageIn)
    }
    
    func processImage(theimage: UIImage) {
        guard let model = try? VNCoreMLModel(for: Fingers_3().model) else {
            print("❌ Kunde inte skapa VNCoreMLModel")
            return
        }
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            if let results = request.results as? [VNClassificationObservation],
               let topResult = results.first {
                DispatchQueue.main.async {
                    self?.resultText = topResult.identifier
                    self?.probability = String(format: "%.2f%%", topResult.confidence * 100)
                }
            } else {
                print("❌ Inga resultat från VNCoreMLRequest: \(error?.localizedDescription ?? "Okänt fel")")
            }
        }
        
        guard let ciImage = CIImage(image: theimage) else {
            print("❌ Kunde inte skapa CIImage från UIImage")
            return
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print("❌ VNImageRequestHandler fel: \(error)")
        }
    }
}
    

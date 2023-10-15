//
//  DetailViewModel.swift
//  alley-test
//
//  Created by abdul karim on 04/10/23.
//

import Foundation
import UIKit
import CoreML
import Vision

class DetailViewModel {
    
    var photos = [UIImage?]()
    var index:Int = 0
    
    init(photos: [UIImage?], index:Int) {
        self.photos = photos
        self.index = index
    }
    
    func getSelectedPhoto() -> UIImage? {
        if index >= photos.count {
            return photos[2]
        }
        return photos[index]
    }
    
    func recognizeImage(in image: UIImage) async throws -> String? {
        guard let cgImage = image.cgImage else {
            return nil
        }
        let model = try VNCoreMLModel(for: SqueezeNet().model)
        let request = VNCoreMLRequest(model: model)
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try handler.perform([request])

        guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else {
            return nil
        }
        // Get the top recognition result
        let identifier = topResult.identifier
        return identifier
    }
    
    func recognizeText(in image: UIImage) async throws -> String? {
        let targetSize = CGSize(width: 500, height: 500)
        
        guard let resizeImage = resizeImage(image, targetSize: targetSize) else {
            throw NSError(domain: "com.alley.app", code: 1, userInfo: ["Error" : "error converting image to CGImage for OCR Text"])
        }
        
        guard let cgImage = resizeImage.cgImage else {
            throw NSError(domain: "com.alley.app", code: 1, userInfo: ["Error" : "error converting image to CGImage for OCR Text"])
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .fast
        try requestHandler.perform([request])
        
        guard let observations = request.results else {
            return nil
        }
        
        var recognizedText = ""
        for observation in observations {
            guard let topCandidate = observation.topCandidates(1).first else {
                continue
            }
            
            recognizedText += topCandidate.string
            recognizedText += "\n" // Add a line break between each recognized block of text
        }
        
        return recognizedText
    }
    
    fileprivate func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage? {
        let rect = CGRect(origin: .zero, size: targetSize)
        UIGraphicsBeginImageContextWithOptions(targetSize, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }

        image.draw(in: rect)

        if let resizedImage = UIGraphicsGetImageFromCurrentImageContext() {
            return resizedImage
        }

        return nil
    }
    
    
    
}

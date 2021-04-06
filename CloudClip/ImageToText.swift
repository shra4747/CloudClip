//
//  ImageToText.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 4/5/21.
//

import SwiftUI
import Foundation
import Vision
import Cocoa

struct ImageToText {
    public func textRecognition(image: NSImage, completion: @escaping (String) -> ()) {
        var imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        guard let cgImage = image.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else { return }

        //Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        //Request
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                print("Error Recognizing Text")
                return
            }

            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            })
            
            completion(String(text[0]))
        }

        //Process Request
        do {
            try handler.perform([request])
        }
        catch {
            print("Error")
        }
    }
}



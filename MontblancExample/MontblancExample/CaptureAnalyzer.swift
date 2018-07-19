//
//  CaptureAnalyzer.swift
//  MontblancExample
//
//  Created by AtsuyaSato on 2018/07/19.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Foundation
import Vision

enum Result<T, E> {
    case success(T)
    case failure(E)
}

enum CaptureAnalyzerError {
    case failedToAccessMLModel
    case failedPerformHandler
}

struct CaptureAnalyzer {
    static var mlModel: VNCoreMLModel?

    static func analyze(pixelBuffer: CVPixelBuffer, _ block: @escaping (Result<String, CaptureAnalyzerError>) -> Void) {
        guard let mlModel = mlModel else {
            block(Result.failure(.failedToAccessMLModel))
            return
        }

        let request = VNCoreMLRequest(model: mlModel) { (request, error) in
            if let result: VNClassificationObservation = request.results?.first as? VNClassificationObservation {
                DispatchQueue.main.async {
                    block(Result.success(result.identifier))
                }
            }
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        do {
            try handler.perform([request])
        } catch {
            block(Result.failure(.failedPerformHandler))
        }
    }

}

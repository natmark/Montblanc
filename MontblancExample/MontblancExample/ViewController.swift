//
//  ViewController.swift
//  MontblancExample
//
//  Created by AtsuyaSato on 2018/07/19.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import UIKit
import Montblanc
import Vision
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var cameraPreviewView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let captureSession = CaptureSession(delegate: self, previewView: self.cameraPreviewView)
        indicatorView.startAnimating()

        let url = URL(string: "https://docs-assets.developer.apple.com/coreml/models/MobileNet.mlmodel")!

        Montblanc.request(url) { result in
            switch result {
            case .success(let model):
                CaptureAnalyzer.mlModel = try? VNCoreMLModel(for: model)

                self.indicatorView.stopAnimating()
                self.indicatorView.isHidden = true
                captureSession.startRunning()
            case .failure(let error):
                Swift.print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        CaptureAnalyzer.analyze(pixelBuffer: pixelBuffer) { result in
            switch result {
            case .success(let identifier):
                self.label.text = identifier
            case .failure(let error):
                Swift.print(error)
            }
        }
    }
}

//
//  File.swift
//  
//
//  Created by Franco Velasco on 1/21/24.
//

import SwiftUI
import AVFoundation

struct CameraBackgroundView: UIViewRepresentable {
    let session: AVCaptureSession
    
    init() {
        self.session = AVCaptureSession()
    }

    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.backgroundColor = .black
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspect
        view.videoPreviewLayer.connection?.videoRotationAngle = 90.0

        return view
    }

    public func updateUIView(_ uiView: VideoPreviewView, context: Context) { }

    class VideoPreviewView: UIView {

        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }

        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
}

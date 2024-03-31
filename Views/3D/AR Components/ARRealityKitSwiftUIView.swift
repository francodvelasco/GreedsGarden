//
//  ARRealityKitSwiftUIView.swift
//  In the absence of VisionOS style RealityKit rendering for SwiftUI,
//  along with the incompability of SceneKit in AR with RealityKit,
//  this will have to suffice for now: rendering any new SwiftUI view
//  as an image, then display it as a material.
//
//  Created by Franco Velasco on 2/16/24.
//

import Foundation
import RealityKit
import ARKit
import SwiftUI

class ARRealityKitSwiftUIView<Content: View> {
    let anchorTitle: String
    let content: () -> Content
    
    var desiredWidth: Float?
    var desiredHeight: Float?
    
    init(anchorTitle: String, content: @escaping () -> Content) {
        self.anchorTitle = anchorTitle
        self.content = content
        
        self.desiredWidth = nil
        self.desiredHeight = nil
    }
    
    init(anchorTitle: String, desiredWidth: Float?, desiredHeight: Float?, content: @escaping () -> Content) {
        self.anchorTitle = anchorTitle
        self.content = content
        
        self.desiredWidth = desiredWidth
        self.desiredHeight = desiredHeight
    }
    
    @MainActor
    func addView(arView: ARView, baseAnchor: AnchorEntity, position: SIMD3<Float>) {
        let imageRenderer = ImageRenderer(content: content())
        guard let uiImage = imageRenderer.uiImage,
              let cgImage = uiImage.cgImage,
              let texture = try? TextureResource.generate(from: cgImage, options: .init(semantic: .color)) else {
            return
        }
        
        // Create material from photo
        var material = SimpleMaterial()
        material.color = .init(texture: .init(texture))
        material.metallic = .float(0)
        material.roughness = .float(0)
        
        if let desiredWidth, let desiredHeight {
            let baseRectangle = MeshResource.generateBox(
                width: desiredWidth,
                height: desiredHeight,
                depth: 0.01,
                cornerRadius: 8
            )
            
            let baseEntity = ModelEntity(mesh: baseRectangle, materials: [material])
            baseEntity.name = anchorTitle
            baseEntity.generateCollisionShapes(recursive: true)
            baseEntity.position = position
            baseAnchor.addChild(baseEntity)
        } else {
            let (width, height) = (uiImage.size.width, uiImage.size.height)
            let aspectRatio = width / height
            
            let desiredWidth = min(Float(width) / 300.0, 0.4)
            let desiredHeight = desiredWidth / Float(aspectRatio)
            
            let baseRectangle = MeshResource.generateBox(
                width: desiredWidth * 1.5,
                height: desiredHeight * 1.5,
                depth: 0.01,
                cornerRadius: 8
            )
            
            let baseEntity = ModelEntity(mesh: baseRectangle, materials: [material])
            baseEntity.name = anchorTitle
            baseEntity.generateCollisionShapes(recursive: true)
            baseEntity.position = position
            baseAnchor.addChild(baseEntity)
        }
    }
}

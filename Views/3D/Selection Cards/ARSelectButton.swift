//
//  File.swift
//  
//
//  Created by Franco Velasco on 2/5/24.
//

import Foundation
import RealityKit
import SwiftUI

class ARSelectButton: ARPresentable {
    static func entity(originPosition: SIMD3<Float>) -> AnchorEntity {
        let anchor = AnchorEntity(world: originPosition)
        
        let anchorPosition: SIMD3<Float> = [
            originPosition.x,
            originPosition.y,
            originPosition.z
        ]
        
        let baseRectangle = MeshResource.generateBox(width: 0.1, height: 0.07, depth: 0.01, cornerRadius: 8)
        let baseRectangleEntity = ModelEntity(mesh: baseRectangle, materials: [self.backgroundMaterial()])
        let basePosition: SIMD3<Float> = [
            anchorPosition.x,
            anchorPosition.y,
            anchorPosition.z
        ]
        
        baseRectangleEntity.name = "SelectorAction-Select"
        baseRectangleEntity.setPosition(basePosition, relativeTo: nil)
        
        let textLabel = MeshResource.generateText(
            "Select",
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 0.75),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail
        )
        let textEntity = ModelEntity(mesh: textLabel)
        let textPosition: SIMD3<Float> = [
            anchorPosition.x - 0.03,
            anchorPosition.y + 0.01,
            anchorPosition.z - 0.04
        ]
        
        textEntity.setPosition(textPosition, relativeTo: nil)
        
        anchor.addChild(baseRectangleEntity)
        anchor.addChild(textEntity)
        anchor.generateCollisionShapes(recursive: true)
        
        anchor.name = "SelectorAction-Select"
        
        return anchor
    }
    static func addToView(arView: ARView, baseAnchor: AnchorEntity, relativePosition: SIMD3<Float>?) {
        guard let relativePosition else { return }
        
        let buttonAnchor = AnchorEntity(world: baseAnchor.position)
        buttonAnchor.name = "SelectorAction-Select"
        
        let baseRectangle = MeshResource.generateBox(
            width: 0.15,
            height: 0.06,
            depth: 0.01,
            cornerRadius: 0.01
        )
        let baseMaterial = SimpleMaterial(color: .blue, isMetallic: true)
        
        let baseRectangleEntity = ModelEntity(
            mesh: baseRectangle,
            materials: [baseMaterial]
        )
        baseRectangleEntity.position = relativePosition
        baseRectangleEntity.name = "SelectorAction-Select-Background"
        buttonAnchor.addChild(baseRectangleEntity)
        
        let textLabel = MeshResource.generateText(
            "Select",
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 0.025),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail
        )
        let textMaterial = SimpleMaterial(color: .darkText, isMetallic: true)
        let textEntity = ModelEntity(mesh: textLabel, materials: [textMaterial])
        textEntity.position = [
            relativePosition.x - 0.075,
            relativePosition.y,
            relativePosition.z + 0.045
        ]
        textEntity.name = "SelectorAction-Select-Text"
        buttonAnchor.addChild(textEntity)
        
        buttonAnchor.generateCollisionShapes(recursive: true)
        baseAnchor.addChild(buttonAnchor)
    }
}

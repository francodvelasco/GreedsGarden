//
//  File.swift
//  
//
//  Created by Franco Velasco on 2/10/24.
//

import Foundation
import RealityKit

class ARAdd1YearButton: ARPresentable {
    static func addToView(arView: ARView, baseAnchor: AnchorEntity, relativePosition: SIMD3<Float>? = nil) {
        let baseRectangle = MeshResource.generateBox(
            width: 0.2,
            height: 0.04,
            depth: 0.1,
            cornerRadius: 0.005
        )
        
        var baseRectangleMaterial = PhysicallyBasedMaterial()
        baseRectangleMaterial.baseColor = .init(tint: .blue)
        
        let baseRectangleEntity = ModelEntity(mesh: baseRectangle, materials: [baseRectangleMaterial])
        baseRectangleEntity.name = "AddYear-1"
        baseRectangleEntity.position = relativePosition!
        baseRectangleEntity.generateCollisionShapes(recursive: true)
        
        let textLabel = MeshResource.generateText(
            "+1 Year",
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 0.04),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail
        )
        let textMaterial = SimpleMaterial(color: .white, isMetallic: true)
        let textEntity = ModelEntity(mesh: textLabel, materials: [textMaterial])
        textEntity.name = "AddYear-1"
        textEntity.transform = Transform(pitch: -.pi / 2)
        
        let textPosition: SIMD3<Float> = [
            -0.1,
            0.02,
            0.03
        ]
        textEntity.setPosition(textPosition, relativeTo: baseRectangleEntity)
        textEntity.generateCollisionShapes(recursive: true)
        
        baseAnchor.addChild(baseRectangleEntity)
        baseAnchor.addChild(textEntity)
    }
    
    static func entity(originPosition: SIMD3<Float>) -> AnchorEntity {
        let anchor = AnchorEntity(world: originPosition)
        
        let anchorPosition: SIMD3<Float> = [
            originPosition.x - 0.2,
            originPosition.y,
            originPosition.z - 0.5
        ]
        
        let baseRectangle = MeshResource.generateBox(
            width: 0.1,
            height: 0.05,
            depth: 0.05,
            cornerRadius: 8
        )
        
        var baseRectangleMaterial = PhysicallyBasedMaterial()
        baseRectangleMaterial.baseColor = .init(tint: .blue)
        
        let baseRectanglePosition: SIMD3<Float> = [
            anchorPosition.x,
            anchorPosition.y,
            anchorPosition.z
        ]
        
        let baseRectangleEntity = ModelEntity(
            mesh: baseRectangle,
            materials: [baseRectangleMaterial]
        )
        baseRectangleEntity.setPosition(baseRectanglePosition, relativeTo: nil)
        
        let textLabel = MeshResource.generateText(
            "Add 1 Year",
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 0.75),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail
        )
        let textEntity = ModelEntity(mesh: textLabel)
        let textPosition: SIMD3<Float> = [
            anchorPosition.x,
            anchorPosition.y + 0.01,
            anchorPosition.z
        ]
        textEntity.setPosition(textPosition, relativeTo: nil)
        
        
        anchor.addChild(baseRectangleEntity)
        anchor.addChild(textEntity)
        anchor.generateCollisionShapes(recursive: true)
        
        anchor.name = "AddYear-1"
        return anchor
    }
}

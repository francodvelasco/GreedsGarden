//
//  File.swift
//  
//
//  Created by Franco Velasco on 2/5/24.
//

import Foundation
import RealityKit
import SwiftUI

class ARPlainSelector: ARPresentable {
    static func entity(originPosition: SIMD3<Float>) -> AnchorEntity {
        let anchorPosition: SIMD3<Float> = [
            originPosition.x,
            originPosition.y + 0.4,
            originPosition.z
        ]
        
        let anchor = AnchorEntity(world: anchorPosition)
        anchor.name = "Selector-Plain"
        
        let baseRectangle = MeshResource.generateBox(width: 0.1, height: 0.07, depth: 0.01, cornerRadius: 8)
        let baseRectangleEntity = ModelEntity(mesh: baseRectangle, materials: [self.backgroundMaterial()])
        let basePosition: SIMD3<Float> = [
            anchorPosition.x,
            anchorPosition.y,
            anchorPosition.z
        ]
        
        baseRectangleEntity.name = "Selector-Plain-Base"
        baseRectangleEntity.setPosition(basePosition, relativeTo: nil)
        
        let textLabel = MeshResource.generateText(
            "Plain",
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 0.75),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail
        )
        let textEntity = ModelEntity(mesh: textLabel)
        // Place the text on the lower left side of the button
        let textPosition: SIMD3<Float> = [
            anchorPosition.x - 0.03,
            anchorPosition.y + 0.01,
            anchorPosition.z - 0.04
        ]
        
        textEntity.name = "Selector-Plain-Title"
        textEntity.setPosition(textPosition, relativeTo: nil)
        
        let sampleAnchor = AnchorEntity(world: anchorPosition)
        do {
            let sampleModel = try ModelEntity.loadModel(named: "Plain_Level1", in: nil)
            let sampleEntity = sampleModel.children.first
            // Place the model on the right side of the button
            let samplePosition: SIMD3<Float> = [
                anchorPosition.x + 0.03,
                anchorPosition.y + 0.01,
                anchorPosition.z
            ]
            
            // Scale it down from the 12cm x 12cm side to the 3cm by 3cm size
            sampleEntity?.scale = [0.25, 0.25, 0.25]
            
            sampleEntity?.name = "Selector-Plain-Sample"
            sampleEntity?.setPosition(samplePosition, relativeTo: nil)
            
            if let sampleEntity {
                sampleAnchor.addChild(sampleEntity)
            }
        } catch {
            print(error)
        }
        
        anchor.addChild(baseRectangleEntity)
        anchor.addChild(textEntity)
        anchor.addChild(sampleAnchor)
        anchor.generateCollisionShapes(recursive: true)
        return anchor
    }
    
    @MainActor static func addToView(arView: ARView, baseAnchor: AnchorEntity, relativePosition: SIMD3<Float>?) {
        guard let relativePosition else { return }
        
        let selectorAnchor = AnchorEntity(world: baseAnchor.position)
        selectorAnchor.name = "Selector-Plain"
        
        let buttonWrapper = ARRealityKitSwiftUIView(anchorTitle: "Selector-Plain-Background", desiredWidth: 0.15, desiredHeight: 0.105) {
            Text("Plain")
                .fontWeight(.medium)
                .padding(8)
                .background(Color.white)
        }
        
        buttonWrapper.addView(arView: arView, baseAnchor: selectorAnchor, position: relativePosition)
        
        /*let baseRectangle = MeshResource.generateBox(
            width: 0.15,
            height: 0.105,
            depth: 0.01,
            cornerRadius: 0.04
        )
        let baseRectangleEntity = ModelEntity(
            mesh: baseRectangle,
            materials: [self.backgroundMaterial()]
        )
        baseRectangleEntity.position = relativePosition
        baseRectangleEntity.name = "Selector-Plain-Background"
        selectorAnchor.addChild(baseRectangleEntity)
        
        let textLabel = MeshResource.generateText(
            "Plain",
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 0.1),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail
        )
        let textMaterial = SimpleMaterial(color: .white, isMetallic: true)
        let textEntity = ModelEntity(mesh: textLabel, materials: [textMaterial])
        textEntity.position = [
            relativePosition.x,
            relativePosition.y + 0.075,
            relativePosition.z + 0.045
        ]
        textEntity.name = "Selector-Plain-Text"
        selectorAnchor.addChild(textEntity)*/
        
        guard let pathName = Bundle.main.path(forResource: "Plain_Level1", ofType: "usdz"),
                  let sampleEntity = try? ModelEntity.loadModel(contentsOf: URL(fileURLWithPath: pathName)) else { return }
        sampleEntity.position = [
            relativePosition.x,
            relativePosition.y - 0.01,
            relativePosition.z + 0.03
        ]
        sampleEntity.setScale([0.45, 0.45, 0.45], relativeTo: sampleEntity)
        sampleEntity.name = "Selector-Plain-ModelSample"
        selectorAnchor.addChild(sampleEntity)
        
        selectorAnchor.generateCollisionShapes(recursive: true)
        baseAnchor.addChild(selectorAnchor)
    }
}

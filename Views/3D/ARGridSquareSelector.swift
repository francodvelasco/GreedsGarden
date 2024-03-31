//
//  ARGridSquareSelector.swift
//
//
//  Created by Franco Velasco on 2/5/24.
//

import Foundation
import RealityKit

class ARGridSquareSelector: ARPresentable {
    static func entity(originPosition: SIMD3<Float>) -> AnchorEntity {
        let anchorPosition: SIMD3<Float> = [
            originPosition.x,
            originPosition.y + 0.4,
            originPosition.z
        ]
        
        let anchor = AnchorEntity(world: anchorPosition)
        anchor.name = "Window-Selector"
        
        let baseRectangle = MeshResource.generateBox(width: 0.24, height: 0.43, depth: 0.01, cornerRadius: 0.02)
        let baseRectangleEntity = ModelEntity(mesh: baseRectangle, materials: [self.backgroundMaterial()])
        let basePosition: SIMD3<Float> = [
            anchorPosition.x,
            anchorPosition.y,
            anchorPosition.z
        ]
        
        baseRectangleEntity.name = "Window-Selector-Base"
        baseRectangleEntity.setPosition(basePosition, relativeTo: nil)
        
        // Show "Select Square" text
        let textLabel = MeshResource.generateText(
            "Select Square",
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 1),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail
        )
        let textEntity = ModelEntity(mesh: textLabel)
        let textPosition: SIMD3<Float> = [
            anchorPosition.x,
            anchorPosition.y + 0.02,
            anchorPosition.z - 0.22
        ]
        
        textEntity.name = "Window-Selector-Title"
        textEntity.setPosition(textPosition, relativeTo: nil)
        
        anchor.addChild(textEntity)
        
        // Create a button for all the possible types
        let agricultureButton = ARAgricultureSelector.entity(originPosition: originPosition)
        let carbonCaptureButton = ARCarbonCaptureSelector.entity(originPosition: originPosition)
        let industryButton = ARIndustrySelector.entity(originPosition: originPosition)
        let plainButton = ARPlainSelector.entity(originPosition: originPosition)
        let homeButton = ARPopulationSelector.entity(originPosition: originPosition)
        let forestButton = ARTreeSelector.entity(originPosition: originPosition)
        
        // Create a button to cancel out of the view, or the confirm the selection
        let cancelButton = ARCancelButton.entity(originPosition: originPosition)
        let selectButton = ARSelectButton.entity(originPosition: originPosition)
        
        
        // Arrange the buttons
        anchor.addChild(agricultureButton)
        anchor.addChild(carbonCaptureButton)
        anchor.addChild(industryButton)
        anchor.addChild(plainButton)
        anchor.addChild(homeButton)
        anchor.addChild(forestButton)
        
        anchor.addChild(cancelButton)
        anchor.addChild(selectButton)
        
        return anchor
    }
    
    @MainActor static func addToView(arView: ARView, baseAnchor: AnchorEntity, relativePosition: SIMD3<Float>? = nil) {
        guard let relativePosition else { return }
        
        let windowAnchor = AnchorEntity(world: baseAnchor.position)
        windowAnchor.name = "Window-Selector"
        
        let baseStartingPosition: SIMD3<Float> = [
            relativePosition.x - 0.195,
            relativePosition.y + 0.3225,
            relativePosition.z
        ]
        
        // Background of the Selector view
        let baseRectangle = MeshResource.generateBox(
            width: 0.39,
            height: 0.645,
            depth: 0.01,
            cornerRadius: 0.08
        )
        let baseRectangleEntity = ModelEntity(mesh: baseRectangle, materials: [self.backgroundMaterial()])
        baseRectangleEntity.position = [
            relativePosition.x,
            relativePosition.y,
            relativePosition.z
        ]
        baseRectangleEntity.name = "Window-Selector-Base"
        windowAnchor.addChild(baseRectangleEntity)
        
        // Add invisible anchor that can be called later for positioning of selected tile
        let selectedTileAnchor = AnchorEntity()
        selectedTileAnchor.position = [
            relativePosition.x,
            relativePosition.y - 0.04,
            relativePosition.z + 0.1
        ]
        selectedTileAnchor.name = "Window-Selector-SelectedTileAnchor"
        windowAnchor.addChild(selectedTileAnchor)
        
        // Show "Select Square" Text
        let textLabel = MeshResource.generateText(
            "Select Square",
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 0.03),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail
        )
        let textMaterial = SimpleMaterial(color: .lightText, isMetallic: false)
        let textEntity = ModelEntity(mesh: textLabel, materials: [textMaterial])
        textEntity.name = "Window-Selector-Title"
        textEntity.position = [
            relativePosition.x,
            baseStartingPosition.y - 0.105 + 0.01,
            baseStartingPosition.z + 0.02
        ]
        windowAnchor.addChild(textEntity)
        
        baseAnchor.addChild(windowAnchor)
        
        // Add all the tile selector buttons
        let agricultureSelectorPosition: SIMD3<Float> = [
            baseStartingPosition.x + 0.105,
            baseStartingPosition.y - 0.2475,
            baseStartingPosition.z + 0.01
        ]
        ARAgricultureSelector.addToView(arView: arView, baseAnchor: baseAnchor, relativePosition: agricultureSelectorPosition)
        
        let carbonCaptureSelectorPosition: SIMD3<Float> = [
            baseStartingPosition.x + 0.285,
            baseStartingPosition.y - 0.2475,
            baseStartingPosition.z + 0.01
        ]
        ARCarbonCaptureSelector.addToView(arView: arView, baseAnchor: baseAnchor, relativePosition: carbonCaptureSelectorPosition)
        
        let industrySelectorPosition: SIMD3<Float> = [
            baseStartingPosition.x + 0.105,
            baseStartingPosition.y - 0.3675,
            baseStartingPosition.z + 0.01
        ]
        ARIndustrySelector.addToView(arView: arView, baseAnchor: baseAnchor, relativePosition: industrySelectorPosition)
        
        let plainSelectorPosition: SIMD3<Float> = [
            baseStartingPosition.x + 0.285,
            baseStartingPosition.y - 0.3675,
            baseStartingPosition.z + 0.01
        ]
        ARPlainSelector.addToView(arView: arView, baseAnchor: baseAnchor, relativePosition: plainSelectorPosition)
        
        let populationSelectorPosition: SIMD3<Float> = [
            baseStartingPosition.x + 0.105,
            baseStartingPosition.y - 0.4875,
            baseStartingPosition.z + 0.01
        ]
        ARPopulationSelector.addToView(arView: arView, baseAnchor: baseAnchor, relativePosition: populationSelectorPosition)
        
        let treeSelectorPosition: SIMD3<Float> = [
            baseStartingPosition.x + 0.285,
            baseStartingPosition.y - 0.4875,
            baseStartingPosition.z + 0.01
        ]
        ARTreeSelector.addToView(arView: arView, baseAnchor: baseAnchor, relativePosition: treeSelectorPosition)
        
        // Add Select / Cancel Buttons for confirming / discarding selection
        let cancelButtonPosition: SIMD3<Float> = [
            baseStartingPosition.x + 0.105,
            baseStartingPosition.y - 0.585,
            baseStartingPosition.z + 0.01
        ]
        ARCancelButton.addToView(arView: arView, baseAnchor: baseAnchor, relativePosition: cancelButtonPosition)
        
        let selectButtonPosition: SIMD3<Float> = [
            baseStartingPosition.x + 0.285,
            baseStartingPosition.y - 0.585,
            baseStartingPosition.z + 0.01
        ]
        ARSelectButton.addToView(arView: arView, baseAnchor: baseAnchor, relativePosition: selectButtonPosition)
    }
}

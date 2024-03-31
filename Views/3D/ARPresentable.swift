//
//  ARPresentable.swift
//
//
//  Created by Franco Velasco on 2/5/24.
//

import Foundation
import RealityKit
import UIKit

protocol ARPresentable {
    static func entity(originPosition: SIMD3<Float>) -> AnchorEntity
    
    static func addToView(arView: ARView, baseAnchor: AnchorEntity, relativePosition: SIMD3<Float>?)
}

protocol ARComponent {
    func entity() -> ModelEntity
}

protocol ARPlaceable {
    func place(view: ARView, origin: SIMD3<Float>)
}

extension ARPresentable {
    static func backgroundMaterial() -> Material {
        var material = PhysicallyBasedMaterial()

        material.baseColor = .init(tint: UIColor(white: 0.7, alpha: 0.85))

        material.metallic = 0.1
        material.roughness = 0.9

        material.blending = .transparent(opacity: .init(floatLiteral: 0.6))

       // material.fresnelFactor = 0.2
        //material.fresnelExponent = 2.0

        //let texture = NoiseTexture(size: 0.2, color1: UIColor.white, color2: UIColor.white.withAlphaComponent(0.95))
        //material.baseColorTexture = texture

        return material
    }
}

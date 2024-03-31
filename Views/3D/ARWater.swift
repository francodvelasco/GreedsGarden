//
//  File.swift
//  
//
//  Created by Franco Velasco on 2/13/24.
//

import Foundation
import RealityKit
import ARKit

class ARWater {
    static func addToView(arView: ARView, baseAnchor: AnchorEntity, waterLevel: WaterLevel, relativePosition: SIMD3<Float>? = nil) {
        let position = relativePosition ?? baseAnchor.position
        
        let waterRectangle = MeshResource.generateBox(
            width: 0.95,
            height: waterLevel.realityKitHeight * 2,
            depth: 0.95,
            cornerRadius: 0.04
        )
        
        var waterMaterial = PhysicallyBasedMaterial()
        waterMaterial.baseColor = PhysicallyBasedMaterial.BaseColor(tint: UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 0.5))
        waterMaterial.roughness = 0.2
        waterMaterial.metallic = 0.1
        waterMaterial.blending = .transparent(opacity: .init(floatLiteral: 0.5))
        
        waterMaterial.anisotropyLevel = .init(floatLiteral: 1.5)
        
        let waterEntity = ModelEntity(mesh: waterRectangle, materials: [waterMaterial])
        waterEntity.name = "Water"
        waterEntity.position = position
        
        baseAnchor.addChild(waterEntity)
    }
    
    /*static func fetchWaterTexture() -> CustomMaterial? {
        guard let device = MTLCreateSystemDefaultDevice(),
              let library = device.makeDefaultLibrary() else {
            return nil
        }
        
        do {
            let shaderMaterial = try CustomMaterial(
                from: PhysicallyBasedMaterial(),
                surfaceShader: CustomMaterial.SurfaceShader(named: "waterShader", in: library))
            return shaderMaterial
        } catch {
            return nil
        }
    }*/
}

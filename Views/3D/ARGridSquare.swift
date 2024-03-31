//
//  File.swift
//  
//
//  Created by Franco Velasco on 2/4/24.
//

import Foundation
import RealityKit
import ARKit
import SwiftUI

extension GridSquare {
    func asARModel() -> ModelEntity? {
        let fileName = self.type.fileName(level: self.elevation.rawValue)
        
        // Handle special case for water
        if fileName.starts(with: "Water") {
            return nil
        }
        
        guard let pathName = Bundle.main.path(forResource: fileName, ofType: "usdz"),
              let entity = try? ModelEntity.loadModel(contentsOf: URL(fileURLWithPath: pathName)) else {
            return nil
        }
        
        entity.name = "GridSquare-\(self.column)-\(self.row)"
        entity.generateCollisionShapes(recursive: true)
        return entity
    }
    
    func placeSquare(view: ARView, originAnchor: AnchorEntity) {
        let squarePosition: SIMD3<Float> = [
            originAnchor.position.x + Float((12 + 1) * (self.column - 3)) / 100.0,
            originAnchor.position.y,
            originAnchor.position.z + Float((12 + 1) * (self.row - 3)) / 100.0
        ]
        
        if let squareEntity = self.asARModel() {
            squareEntity.setPosition(squarePosition, relativeTo: nil)
            originAnchor.addChild(squareEntity)
        } else {
            print("==== Entity not found")
        }
    }
    
    func placeSquare(view: ARView, originAnchor: AnchorEntity, placedPosition: SIMD3<Float>) {
        if let squareEntity = self.asARModel() {
            squareEntity.setPosition(placedPosition, relativeTo: nil)
            originAnchor.addChild(squareEntity)
        }
    }
}

extension GridSquareType {
    func fileName(level: Int) -> String {
        switch self {
        case .plain:
            return "Plain_Level\(level)"
        case .agriculture:
            return "Agriculture_Level\(level)"
        case .trees(let stage):
            return "Tree_Stage\(stage.rawValue)_Level\(level)"
        case .industry:
            return "Industry_Level\(level)"
        case .population(let houseType):
            return "House_\(houseType.rawValue.capitalized)_Level\(level)"
        case .carbon_capture:
            return "CarbonCapture_Level\(level)"
        case .water(_):
            return "Water_Level\(level)"
        }
    }
    
    func asModelEntity(column: Int, row: Int, elevation: Elevation) -> ModelEntity? {
        let fileName = self.fileName(level: elevation.rawValue)
        
        // Handle special case for water
        if fileName.starts(with: "Water") {
            return nil
        }
        
        guard let pathName = Bundle.main.path(forResource: fileName, ofType: "usdz"),
              let entity = try? ModelEntity.loadModel(contentsOf: URL(fileURLWithPath: pathName)) else {
            return nil
        }
        
        entity.name = "GridSquare-\(column)-\(row)"
        entity.generateCollisionShapes(recursive: true)
        return entity
    }
    
    func placeSquare(column: Int, row: Int, elevation: Elevation,
                     view: ARView, originAnchor: AnchorEntity, placedPosition: SIMD3<Float>) {
        if let squareEntity = self.asModelEntity(column: column, row: row, elevation: elevation) {
            squareEntity.setPosition(placedPosition, relativeTo: originAnchor)
            originAnchor.addChild(squareEntity)
        }
    }
}

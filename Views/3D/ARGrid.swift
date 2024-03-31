//
//  File.swift
//  
//
//  Created by Franco Velasco on 2/6/24.
//

import Foundation
import RealityKit
import ARKit

extension Grid {
    func placeGrid(view: ARView, originAnchor: AnchorEntity) {
        for tile in self.gridTiles {
            tile.placeSquare(view: view, originAnchor: originAnchor)
        }
    }
}

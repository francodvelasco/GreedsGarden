//
//  File.swift
//  
//
//  Created by Franco Velasco on 1/28/24.
//

import Foundation
import SceneKit
import SwiftUI

struct TileModelView: View {
    var scene: SCNScene
    var sceneNode: SCNNode
    
    init?(tileName: String) {
        let usdzURL = URL(filePath: "Assets/3D Models/Tree_5.usdz")
        self.scene = try! SCNScene(url: usdzURL, options: [.checkConsistency: true])
        self.sceneNode = self.scene.rootNode
    }
    
    var body: some View {
        SceneView(scene: scene)
    }
}

#Preview {
    TileModelView(tileName: "Tree_5")
}

//
//  File.swift
//  
//
//  Created by Franco Velasco on 2/8/24.
//

import Foundation
import SwiftUI
import SceneKit

struct ModelTemplateView: View {
    @State var coordinator: ModelTemplateViewCoordinator
    
    init(modelType: GridSquareType) {
        self.coordinator = ModelTemplateViewCoordinator(modelType: modelType)
    }
    
    var body: some View {
        if let scene = coordinator.scene {
            SceneView(
                scene: scene,
                //pointOfView: coordinator.pointOfView,
                options: [.autoenablesDefaultLighting]
            )
        } else {
            Text(coordinator.text)
        }
    }
}

class ModelTemplateViewCoordinator: ObservableObject {
    let modelType: GridSquareType
    var text: String = ""
    
    init(modelType: GridSquareType) {
        self.modelType = modelType
    }
    
    lazy var scene: SCNScene? = {
        let fileName = modelType.fileName(level: 1)
        guard let pathName = Bundle.main.path(forResource: fileName, ofType: "usdz") else {
            text = "Path Not Found, \(fileName)"
            return nil
        }
        let fileURL = URL(fileURLWithPath: pathName)
        
        do {
            let scene: SCNScene = try SCNScene(url: fileURL)
            return scene
        } catch {
            text = "Scene Failed"
            return nil
        }
    }()
    
    lazy var pointOfView: SCNNode = {
        let node = SCNNode()
        node.camera = SCNCamera()
        node.position = SCNVector3(0, -20, 0)
        node.look(at: SCNVector3(0, 0, 0))
        
        return node
    }()
}

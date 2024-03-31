//
//  ARSwiftUIView.swift
//
//
//  Created by Franco Velasco on 2/7/24.
//

import Foundation
import RealityKit
import ARKit
import SwiftUI

class ARSceneKitSwiftUIView<Content: View> {
    let content: () -> Content
    let width: CGFloat
    let height: CGFloat
    
    init(width: CGFloat, height: CGFloat, content: @escaping () -> Content) {
        self.width = width
        self.height = height
        self.content = content
    }
    
    func viewToNode() -> SCNNode {
        let node = SCNNode()
        
        let plane = SCNPlane(width: width, height: height)
        let planeNode = SCNNode(geometry: plane)
        
        let convertedView = UIHostingController(rootView: content())
        
        DispatchQueue.main.async { [self] in
            convertedView.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
            convertedView.view.isOpaque = false
            
            let backgroundMaterial = SCNMaterial()
            backgroundMaterial.diffuse.contents = convertedView.view
            node.geometry?.materials = [backgroundMaterial]
            
            convertedView.view.backgroundColor = UIColor.clear
            
            node.addChildNode(planeNode)
        }
        
        return node
    }
}

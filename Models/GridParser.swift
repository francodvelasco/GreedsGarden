//
//  File.swift
//  
//
//  Created by Franco Velasco on 1/22/24.
//

import Foundation

class GridParser {
    enum World: String {
        case World1, World2, World3
    }
    
    static func fetchGrid(_ world: World = .World1) -> [GridSquare] {
        do {
            guard let path = Bundle.main.path(forResource: world.rawValue, ofType: "json"),
                  let data = try String(contentsOfFile: path).data(using: .utf8) else {
                return []
            }
            
            let items: [GridSquare] = try JSONDecoder().decode([GridSquare].self, from: data)
            return items
            
        } catch {
            return []
        }
    }
    
    static func generateWorld(_ world: World = .World1) throws -> Grid {
        let tiles = self.fetchGrid(world)
        return Grid(gridTiles: tiles)
    }
}

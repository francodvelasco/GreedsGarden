//
//  File.swift
//  
//
//  Created by Franco Velasco on 1/18/24.
//

import Foundation

final class GridSquare: Hashable, Decodable {
    var type: GridSquareType
    var elevation: Elevation
    
    var column: Int = 0
    var row: Int = 0
    
    var age: Int = 0
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(column)
        hasher.combine(row)
        hasher.combine(elevation)
    }
    
    static func == (lhs: GridSquare, rhs: GridSquare) -> Bool {
        lhs.column == rhs.column && lhs.row == rhs.row
    }
    
    init(type: GridSquareType, elevation: Elevation) {
        self.type = type
        self.elevation = elevation
    }
    
    init(column: Int, row: Int, type: GridSquareType, height: Int) {
        self.column = column
        self.row = row
        self.elevation = Elevation(rawValue: height)!
        
        self.type = type
    }
    
    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let column = try container.decode(Int.self, forKey: .column)
        let row = try container.decode(Int.self, forKey: .row)
        let height = try container.decode(Int.self, forKey: .height)
        
        let typeString = try container.decode(String.self, forKey: .type)
        let houseType = try container.decodeIfPresent(String.self, forKey: .house_type)
        let treeStage = try container.decodeIfPresent(Int.self, forKey: .tree_stage)
        
        let type = GridSquareType(typeString, houseType: houseType, treeStage: treeStage)
        
        self.init(column: column, row: row, type: type, height: height)
    }
    
    enum CodingKeys: String, CodingKey {
        case type, height, column, row, house_type, tree_stage
    }
    
    func ageUp(_ increase: Int = 1) -> GridSquareType? {
        switch type {
            case .plain, .agriculture, .industry, .carbon_capture, .water(_), .trees(.grown):
                self.age += increase
                return nil
            
            case .trees(let treeStage):
                let (newStage, newAge) = treeStage.nextStage(currentAge: self.age, increase: increase)
                self.type = .trees(newStage)
                self.age = newAge
                return self.type
            
            case .population(let houseType):
                let newAge = self.age + increase
                if newAge >= 10 && houseType == .poor {
                    self.type = .population(.rich)
                    self.age = newAge - 10
                    return self.type
                } else {
                    self.age = newAge
                    return nil
                }
        }
    }
    
    func replaceType(_ newType: GridSquareType) {
        self.type = newType
        self.age = 0
    }
}

struct GridSquareLocation: Hashable, Equatable {
    var column: Int
    var row: Int
    var elevation: Elevation
    
    init(column: Int, row: Int, elevation: Elevation) {
        self.column = column
        self.row = row
        self.elevation = elevation
    }
    
    init(tile: GridSquare) {
        self.column = tile.column
        self.row = tile.row
        self.elevation = tile.elevation
    }
    
    static func ==(lhs: GridSquareLocation, rhs: GridSquareLocation) -> Bool {
        lhs.column == rhs.column && lhs.row == rhs.row
    }
}

enum GridSquareType: Hashable, Equatable {
     case plain,
          agriculture,
          trees(TreeStage),
          industry,
          population(HouseType),
          carbon_capture,
          water(WaterLevel)
    
    init?(from title: String.SubSequence) {
        switch title {
        case "Agriculture":
            self = .agriculture
        case "CarbonCapture":
            self = .carbon_capture
        case "Industry":
            self = .industry
        case "Plain":
            self = .plain
        case "Home", "Population", "PoorPopulation":
            self = .population(.poor)
        case "RichPopulation":
            self = .population(.rich)
        case "Tree":
            self = .trees(.new)
        default:
            return nil
        }
    }
    
    init(_ typeString: String, houseType: String? = nil, treeStage: Int? = nil) {
        switch typeString {
            case "agriculture":
                self = .agriculture
            case "plain":
                self = .plain
            case "tree" where treeStage != nil:
                self = .trees(TreeStage(rawValue: treeStage!)!)
            case "house" where houseType != nil:
                self = .population(HouseType(rawValue: houseType!)!)
            default:
                self = .water(.level0)
        }
    }
    
    static func ==(lhs: GridSquareType, rhs: GridSquareType) -> Bool {
        switch (lhs, rhs) {
            case (.plain, .plain), (.agriculture, .agriculture), (.industry, .industry), (.carbon_capture, .carbon_capture), (.water(_), .water(_)):
                return true
            case (.trees(let l), .trees(let r)):
                return l == r
            case (.population(let l), .population(let r)):
                return l == r
            default:
                return false
        }
    }
}

enum TreeStage: Int {
    case new = 0, low_mid, mid, mid_high, grown
    
    func nextStage(currentAge: Int, increase: Int) -> (tree: TreeStage, newAge: Int) {
        let rawAge = self.rawValue * 7 + currentAge + increase
        
        switch rawAge {
            case 0...6:
                return (.new, rawAge)
            case 7...13:
                return (.low_mid, rawAge % 7)
            case 14...20:
                return (.mid, rawAge % 7)
            case 21...27:
                return (.mid_high, rawAge % 7)
            case 28...:
                return (.grown, max(rawAge % 7, rawAge - 28))
            default:
                return (.new, 0)
        }
    }
}

enum WaterLevel: Int {
    case level0 = 0, level1, level2
    
    var height: Float {
        switch self {
        case .level0:
            return 7.5
        case .level1:
            return 12.5
        case .level2:
            return 17.5
        }
    }
    
    var realityKitHeight: Float { return height / 100.0 }
    
    static func <= (lhs: Elevation, rhs: WaterLevel) -> Bool {
        return lhs.rawValue <= rhs.rawValue
    }
    
    static func +(lhs: WaterLevel, rhs: WaterLevel) -> WaterLevel {
        let totalVal = lhs.rawValue + rhs.rawValue
        let normalizedVal = min(2, max(0, totalVal))
        
        return WaterLevel(rawValue: normalizedVal)!
    }
    
    static func -(lhs: WaterLevel, rhs: WaterLevel) -> WaterLevel {
        let totalVal = lhs.rawValue - rhs.rawValue
        let normalizedVal = min(2, max(0, totalVal))
        
        return WaterLevel(rawValue: normalizedVal)!
    }
    
    static func +(lhs: WaterLevel, rhs: Int) -> WaterLevel {
        let totalVal = lhs.rawValue + rhs
        let normalizedVal = min(2, max(0, totalVal))
        
        return WaterLevel(rawValue: normalizedVal)!
    }
    
    static func -(lhs: WaterLevel, rhs: Int) -> WaterLevel {
        let totalVal = lhs.rawValue - rhs
        let normalizedVal = min(2, max(0, totalVal))
        
        return WaterLevel(rawValue: normalizedVal)!
    }
}

enum Elevation: Int {
    case level1 = 1, level2 = 2, level3 = 3
    
    var height: Float {
        switch self {
            case .level1:
                return 10.0
            case .level2:
                return 15.0
            case .level3:
                return 20.0
        }
    }
    
    var realityKitHeight: Float { return height / 100.0 }
}

/*protocol ComparableWithEnum<Enum: Int> {
    static func <= (lhs: Self, rhs: Enum) -> Bool {
        return lhs.rawValue <= rhs.rawValue
    }
}*/

enum HouseType: String {
    case poor, rich
}

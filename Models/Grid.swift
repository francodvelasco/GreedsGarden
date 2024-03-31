//
//  File.swift
//  
//
//  Created by Franco Velasco on 1/21/24.
//

import Foundation

class Grid {
    var gridTiles: [GridSquare] = []
    
    var moneyLevel: MetricLevel = .middle(45)
    var moneyLevelAge: Int = 0
    
    var pollutionLevel: MetricLevel = .middle(95)
    var pollutionLevelAge: Int = 0
    
    var currentWaterLevel: WaterLevel = .level0
    var raiseWaterCount: Int = 0
    
    var happinessLevel: MetricLevel = .middle(95)
    var happinessLevelAge: Int = 0
    
    var currentYear: Int = 0
    
    var currentGameStage: StoryStage = .introduction
    
    init(gridTiles: [GridSquare]) {
        self.gridTiles = gridTiles
    }
    
    init(gridMapOptions: GridParser.World) {
        self.gridTiles = GridParser.fetchGrid(gridMapOptions)
    }
    
    func setGrid(_ world: GridParser.World) {
        self.gridTiles = GridParser.fetchGrid(world)
    }
    
    func setMetrics() {
        var (rawMoney, rawPollution, rawHappiness) = (moneyLevel.rawScore, pollutionLevel.rawScore, happinessLevel.rawValue)
        
        let gridTypeCounts = getFilteredGridTypeCounts()
        
        // Deal with how much money the world is earning
        // Factors:
        // Agriculture +4
        // Industry +20
        // Carbon Capture -16
        rawMoney += gridTypeCounts[.agriculture, default: 0] * 4
        rawMoney += gridTypeCounts[.industry, default: 0] * 20
        rawMoney -= gridTypeCounts[.carbon_capture, default: 0] * 30
        
        // Deal with how much pollution is generated
        // Factors:
        // Population, Poor: +4
        // Population, Rich: +16
        // Industry: +29
        // Tree, Stage 3: -3
        // Tree, Stage 4: -13
        // Tree, Stage 5: -22
        // Agriculture: -2
        // Carbon Capture: -10
        // Plain: -1
        rawPollution += gridTypeCounts[.population(.poor), default: 0] * 4
        rawPollution += gridTypeCounts[.population(.rich), default: 0] * 16
        rawPollution += gridTypeCounts[.industry, default: 0] * 29
        rawPollution -= gridTypeCounts[.trees(.mid), default: 0] * 3
        rawPollution -= gridTypeCounts[.trees(.mid_high), default: 0] * 13
        rawPollution -= gridTypeCounts[.trees(.grown), default: 0] * 22
        rawPollution -= gridTypeCounts[.agriculture, default: 0] * 2
        rawPollution -= gridTypeCounts[.carbon_capture, default: 0] * 10
        rawPollution -= gridTypeCounts[.plain, default: 0]
        
        // Deal with how much happiness exists within the population
        // Happiness will only increase greatly if there's a new thing built
        // Some happiness will be maintained from what the population have
        rawHappiness += gridTypeCounts[.agriculture, default: 0] * (gridTypeCounts[.population(.poor), default: 0] + gridTypeCounts[.population(.rich), default: 0])
        rawHappiness += gridTypeCounts[.industry, default: 0] * gridTypeCounts[.population(.rich), default: 0] * 3
        
        // Their happiness also diminishes over time
        // Higher for richer people, as they demand more out of society
        // Pollution also plays a factor
        rawHappiness -= gridTypeCounts[.population(.poor), default: 0]
        rawHappiness -= gridTypeCounts[.population(.rich), default: 0] * 3
        rawHappiness -= (gridTypeCounts[.population(.poor), default: 0] + gridTypeCounts[.population(.rich), default: 0]) * (rawPollution / 60)
        
        // Min-max (ish) normalization for conversion to MetricLevels
        (rawMoney, rawHappiness, rawPollution) = (max(rawMoney, 0), max(rawHappiness, 0), max(rawPollution, 0))
        (rawMoney, rawHappiness, rawPollution) = (min(rawMoney, 200), min(rawHappiness, 200), min(rawPollution, 200))
        
        var (newMoneyLevel, newHappinessLevel, newPollutionLevel) = (MetricLevel.zero(0), MetricLevel.zero(0), MetricLevel.zero(0))
        
        switch rawMoney {
            case 1...25:
                newMoneyLevel = .lowest(rawMoney)
            case 26...50:
                newMoneyLevel = .low_mid(rawMoney)
            case 51...100:
                newMoneyLevel = .middle(rawMoney)
            case 101...150:
                newMoneyLevel = .mid_high(rawMoney)
            case 151...200:
                newMoneyLevel = .highest(rawMoney)
            default:
                newMoneyLevel = .zero(0)
        }
        
        switch rawHappiness {
            case 1...25:
                newHappinessLevel = .lowest(rawHappiness)
            case 26...50:
                newHappinessLevel = .low_mid(rawHappiness)
            case 51...100:
                newHappinessLevel = .middle(rawHappiness)
            case 101...150:
                newHappinessLevel = .mid_high(rawHappiness)
            case 151...200:
                newHappinessLevel = .highest(rawHappiness)
            default:
                newHappinessLevel = .zero(0)
        }
        
        switch rawPollution {
            case 1...25:
                newPollutionLevel = .lowest(rawPollution)
            case 26...50:
                newPollutionLevel = .low_mid(rawPollution)
            case 51...100:
                newPollutionLevel = .middle(rawPollution)
            case 101...150:
                newPollutionLevel = .mid_high(rawPollution)
            case 151...200:
                newPollutionLevel = .highest(rawPollution)
            default:
                newPollutionLevel = .zero(0)
        }
        
        if self.moneyLevel == newMoneyLevel {
            moneyLevelAge += 1
        } else {
            moneyLevelAge = 0
        }
        
        if self.happinessLevel == newHappinessLevel {
            happinessLevelAge += 1
        } else {
            happinessLevelAge = 0
        }
        
        if self.pollutionLevel == newPollutionLevel {
            pollutionLevelAge += 1
        } else {
            pollutionLevelAge = 0
        }
        
        self.moneyLevel = newMoneyLevel
        self.happinessLevel = newHappinessLevel
        self.pollutionLevel = newPollutionLevel
    }
    
    typealias GridUpdateInfo = [GridSquareLocation: GridSquareType]
    func ageUp(_ increase: Int = 1) -> GridUpdateInfo {
        var output: GridUpdateInfo = [:]
        
        self.currentYear += increase
        
        for _ in 1...increase {
            // Age up everything in the grid by 1
            for tile in gridTiles {
                let newType = tile.ageUp()
                
                if let newType {
                    output[
                        GridSquareLocation(tile: tile)
                    ] = newType
                }
            }
            
            // Calculate new metrics
            self.setMetrics()
            
            // With new metrics, calculate change in water level
            self.changeWaterLevel()
        }
        
        
        
        return output
    }
    
    func getFilteredGridTypeCounts() -> [GridSquareType: Int] {
        var temp: [GridSquareType: Int] = [:]
        
        for tile in gridTiles {
            // If tile is flooded, don't count as a valid tile
            if tile.elevation <= currentWaterLevel { continue }
            
            switch tile.type {
            case .plain,
                    .agriculture,
                    .trees(_), .population(_), .water(_),
                    .carbon_capture where tile.age >= 5,
                    .industry where tile.age >= 5:
                temp[tile.type, default: 0] += 1
            default:
                continue
            }
        }
        
        return temp
    }
    
    func changeWaterLevel() {
        // Higher levels of pollution = water levels going up
        if case .mid_high(_) = pollutionLevel { self.raiseWaterCountIncrement(1)
        } else if case .highest(_) = pollutionLevel {
            self.raiseWaterCountIncrement(4)
        } else {
            self.raiseWaterCountIncrement(-1)
        }
        
        if self.raiseWaterCount >= 20 {
            self.currentWaterLevel = .level2
        } else if self.raiseWaterCount >= 10 {
            self.currentWaterLevel = .level1
        } else {
            self.currentWaterLevel = .level0
        }
    }
    
    func addIndustryHappiness() {
        self.moneyLevel = self.moneyLevel.moveUp()
    }
    
    func canBeBuilt(_ newType: GridSquareType) -> Bool {
        return (newType == .carbon_capture && moneyLevel == .mid_high(150)) || (newType == .industry && moneyLevel == .middle(100))
        || (newType != .carbon_capture && newType != .industry)
    }
    
    enum GameOverTypes {
        case NoMoney, NoHappiness, FullPollution, LowMoney, LowHappiness, HighPollution
        
        var reasonText: String {
            switch self {
            case .NoMoney:
                return "You ran out of money!"
            case .NoHappiness:
                return "Your people are entirely unhappy!"
            case .FullPollution:
                return "Your land is incredibly polluted!"
            case .LowMoney:
                return "You've been low on money for a while!"
            case .LowHappiness:
                return "Your people have been unhappy for a while!"
            case .HighPollution:
                return "Your land has been polluted for a while!"
            }
        }
    }
    
    func gameOver() -> GameOverTypes? {
        // Money is at 0 for 3 years
        if (self.moneyLevel.rawValue == 1 && self.moneyLevelAge >= 3) { return .NoMoney }
        
        // Happiness is at 0 for 3 years
        if (self.happinessLevel.rawValue == 1 && self.happinessLevelAge >= 3) { return .NoHappiness }
        
        // Pollution at max for 3 years
        if (self.pollutionLevel.rawValue == 6 && self.pollutionLevelAge >= 3) { return .FullPollution }
        
        // Money is at lowest for 6 years
        if (self.moneyLevel.rawValue == 2 && self.moneyLevelAge >= 35) { return .LowMoney }
        
        // Happiness is at lowest for 6 years
        if (self.happinessLevel.rawValue == 2 && self.pollutionLevelAge >= 35) { return .LowHappiness }
        
        // Pollution is at mid_high for 6 years
        if (self.pollutionLevel.rawValue == 5 && self.pollutionLevelAge >= 35) { return .HighPollution }
        
        return nil
    }
    
    func raiseWaterCountIncrement(_ amount: Int) {
        let newWaterCount = self.raiseWaterCount + amount
        
        self.raiseWaterCount = min(25, max(newWaterCount, 0))
    }
}

enum MetricLevel: Comparable {
    case zero(Int), lowest(Int), low_mid(Int), middle(Int), mid_high(Int), highest(Int)
    
    var rawScore: Int {
        switch self {
        case .zero(let s), .lowest(let s), .low_mid(let s), .middle(let s), .mid_high(let s), .highest(let s):
            return s
        }
    }
    
    var rawValue: Int {
        switch self {
            case .zero(_):
                return 1
            case .lowest(_):
                return 2
            case .low_mid(_):
                return 3
            case .middle(_):
                return 4
            case .mid_high(_):
                return 5
            case .highest(_):
                return 6
        }
    }
    
    func moveUp() -> MetricLevel {
        switch self {
            case .zero(_):
                return .lowest(25)
            case .lowest(_):
                return .low_mid(50)
            case .low_mid(_):
                return .middle(100)
            case .middle(_):
                return .mid_high(150)
            case .mid_high(_), .highest(_):
                return .highest(200)
        }
    }
    
    static func ==(lhs: MetricLevel, rhs: MetricLevel) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    static func <=(lhs: MetricLevel, rhs: MetricLevel) -> Bool {
        return lhs.rawValue <= rhs.rawValue
    }
    
    static func <(lhs: MetricLevel, rhs: MetricLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    static func >=(lhs: MetricLevel, rhs: MetricLevel) -> Bool {
        return lhs.rawValue >= rhs.rawValue
    }
    
    static func >(lhs: MetricLevel, rhs: MetricLevel) -> Bool {
        return lhs.rawValue > rhs.rawValue
    }
}

enum StoryStage {
    case introduction,
        main_instructions,
        tile_information,
        main_game,
        game_over
}

extension Array where Element == GridSquare {
    func fetch(col: Int, row: Int) -> GridSquare? {
        return self.first { tile in
            tile.column == col && tile.row == row
        }
    }
}

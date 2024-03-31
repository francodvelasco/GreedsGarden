//
//  File.swift
//  
//
//  Created by Franco Velasco on 2/4/24.
//

import Foundation
import SwiftUI
import RealityKit
import ARKit

struct ARHubView: UIViewRepresentable {
    typealias UIViewType = ARView
    typealias Coordinator = ARHubViewCoordinator
    
    @Binding var isLoading: Bool
    @Binding var loadingText: String
    
    let view = ARView(frame: .init(x: 1, y: 1, width: 1, height: 1), cameraMode: .ar, automaticallyConfigureSession: false)
    let originAnchor: AnchorEntity = AnchorEntity(
        .plane(.horizontal,
               classification: .any,
               minimumBounds: [0.0, 0.0]
        ))
    
    func makeUIView(context: Context) -> ARView {
        view.session.delegate = context.coordinator
        self.loadingText = "Keep your device's rear camera pointed at a flat surface!"
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        view.session.run(configuration)
        
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.tapView(_:)))
        )
        
        // Put the Intro View
        let arIntroView = ARRealityKitSwiftUIView(anchorTitle: "Introduction") {
            IntroView()
        }
        
        let arIntroPosition: SIMD3<Float> = [
            originAnchor.position.x,
            originAnchor.position.y + 0.2,
            originAnchor.position.z
        ]
        
        arIntroView.addView(arView: view, baseAnchor: originAnchor, position: arIntroPosition)
        self.isLoading = false
        
        view.scene.addAnchor(originAnchor)
        return view
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        self.isLoading = true
    }
    
    func makeCoordinator() -> ARHubViewCoordinator {
        return ARHubViewCoordinator(parent: self)
    }
}

class ARHubViewCoordinator: NSObject, ARSessionDelegate {
    let grid = Grid(gridMapOptions: .World3)
    
    var parent: ARHubView
    var selectedType: GridSquareType? = nil
    var selectedTile: (column: Int, row: Int)? = nil
    var currentlySelectedGrid: RealityKit.Entity? = nil
    
    var infoViewTappedCount: Int = 0
    
    init(parent: ARHubView) {
        self.parent = parent
        super.init()
    }
    
    @MainActor @objc func tapView(_ gesture: UIGestureRecognizer) {
        // Through raycasting, determine which entity was tapped in the scene
        let tappedLoc = gesture.location(in: parent.view)
        
        guard let ray = parent.view.ray(through: tappedLoc) else {
            return
        }
        
        let rayResults = parent.view.scene.raycast(origin: ray.origin, direction: ray.direction)
        
        guard let rayResult = rayResults.first else {
            return
        }
        
        let tappedEntity = rayResult.entity
        let tappedEntityName = tappedEntity.name
        let tappedEntityDetails = tappedEntityName.split(separator: "-")
        print("Tapped Entity: \(tappedEntityName)")
        
        // Entities have the code name type-attribute...
        // The type of the tapped Entity determines the action done
        let tappedEnum: TapActionType? = TapActionType(rawValue: String(tappedEntityDetails[0]))
        
        switch tappedEnum {
        case _ where grid.currentGameStage == .game_over:
            // Game over, do nothing
            return
            
        case .grid where grid.currentGameStage == .main_game:
            let (column, row) = (tappedEntityDetails[1], tappedEntityDetails[2])
            self.currentlySelectedGrid = tappedEntity
            
            self.tapGrid(
                entity: tappedEntity,
                column: column,
                row: row
            )
            
        case .dismiss_instruction, .no_money_alert:
            self.removeEntityAnimated(tappedEntity)
            
        case .main_instruction: // Dismiss main instruction from world
            // Remove main instruction
            self.removeEntityAnimated(tappedEntity)
            
            // Add description views
            self.addDescriptorViews()
            
        case .descriptor:
            // Remove the tapped information
            self.removeEntityAnimated(tappedEntity)
            
            self.infoViewTappedCount += 1
            
            if infoViewTappedCount == 8 {
                self.addButtonDescriptions()
                
                self.addButtons()
            }
            
        case .add_year: // Tapped an add year button
            let yearsToAdd = Int(tappedEntityDetails[1])
            
            self.addYear(yearsToAdd)
            
            // Check if game is over, change things accordingly
            if let gameOverReason = grid.gameOver() {
                self.addGameOverView(reason: gameOverReason)
                self.grid.currentGameStage = .game_over
            }
        case .button_description: // Dismiss the button description
            // Remove Button Descriptions
            self.removeEntityAnimated(tappedEntity)
            
            // Add the Metric View
            self.addMetricBoard()
            
            // Start the game!
            grid.currentGameStage = .main_game
            
        case .introduction: // Dismiss the main introduction
            // Remove the introduction
            self.removeEntityAnimated(tappedEntity)
            
            // Add the main instruction
            self.addMainIntroView()
            
            // Add the world
            self.buildWorld()
            
        case .selected_change_tile: // Selected new tile type
            let newSelectedType = GridSquareType(from: tappedEntityDetails[1])
            
            self.selectedType = newSelectedType
            
            // Change the one that is currently displayed
            self.tappedSelector(
                entity: currentlySelectedGrid,
                column: selectedTile!.column,
                row: selectedTile!.row,
                toType: self.selectedType!
            )
            
        case .confirm_change_tile:
            let desiredAction = tappedEntityDetails[1]
            
            // Remove selector window
            self.removeFullWindow()
            
            // Put back tile
            
            guard let selectedType else { return }
            
            if desiredAction == "Select", 
                !grid.canBeBuilt(selectedType) {
                self.returnTile(
                    entity: currentlySelectedGrid,
                    column: self.selectedTile!.column,
                    row: self.selectedTile!.row
                )
                
                self.addNoMoneyView()
                
                self.currentlySelectedGrid = nil
                self.selectedTile = nil
                self.selectedType = nil
                
                return
            }
            
            if desiredAction == "Select", 
                let column = selectedTile?.column,
                let row = selectedTile?.row {
                self.selectedGrid(
                    column: column,
                    row: row,
                    toType: selectedType
                )
                
                self.returnTile(
                    entity: currentlySelectedGrid,
                    column: self.selectedTile!.column,
                    row: self.selectedTile!.row
                )
            }
            
            self.currentlySelectedGrid = nil
            self.selectedTile = nil
            self.selectedType = nil
        default:
            return
        }
    }
    
    enum TapActionType: String {
        case grid = "GridSquare",
             dismiss_instruction,
             main_instruction = "MainIntro",
             information,
             descriptor = "Descriptor",
             add_year = "AddYear",
             button_description = "ButtonDescription",
            introduction = "Introduction",
            selected_change_tile = "Selector",
            confirm_change_tile = "SelectorAction",
            no_money_alert = "NoMoney"
    }
    
    @MainActor func tapGrid(entity: Entity, column: String.SubSequence, row: String.SubSequence) {
        // Internally note selected tile
        self.selectedTile = (
            Int(column), Int(row)
        )
        
        let selectorBasePosition: SIMD3<Float> = [
            parent.originAnchor.position.x,
            parent.originAnchor.position.y + 0.25,
            parent.originAnchor.position.z
        ]
        
        // Create selector background
        ARGridSquareSelector.addToView(arView: parent.view, baseAnchor: parent.originAnchor, relativePosition: selectorBasePosition)
        
        // Move the tapped grid tile to the position within the selector
        guard let markerAnchor = parent.view.scene.findEntity(named: "Window-Selector-SelectedTileAnchor") else {
            print("===== Marker Anchor Not Found")
            return
        }
        
        let moveLocation: SIMD3<Float> = markerAnchor.position(relativeTo: parent.originAnchor)
        
        let moveTransformAmount: SIMD3<Float> = moveLocation - entity.position(relativeTo: parent.originAnchor)
        
        let moveTransform = Transform(translation: moveTransformAmount)
        entity.move(to: moveTransform, relativeTo: entity, duration: 0.5)
    }
    
    func tappedSelector(entity: Entity?, column: Int, row: Int, toType: GridSquareType) {
        // Change the selected tile
        guard let entity else {
            print("==== Wow! Not Found!")
            return
        }

        self.removeEntityAnimated(entity)
        
        guard let markerAnchor = parent.view.scene.findEntity(named: "Window-Selector-SelectedTileAnchor") else {
            print("===== Marker Anchor Not Found")
            return
        }
        
        let currentLocation = markerAnchor.position(relativeTo: parent.originAnchor)
        
        let currentElevation = self.grid.gridTiles.fetch(col: column, row: row)!.elevation
        toType.placeSquare(
            column: column, row: row, elevation: currentElevation,
            view: parent.view, originAnchor: parent.originAnchor,
            placedPosition: currentLocation
        )
    }
    
    @MainActor 
    func selectedGrid(column: Int, row: Int, toType: GridSquareType) {
        // Change grid internally
        let tile = self.grid.gridTiles.fetch(col: column, row: row)
        tile?.replaceType(toType)
        
        // Add industry happiness if a new industry tile is placed
        if toType == .industry {
            grid.addIndustryHappiness()
            
            // Re-render metric board to show updated happiness
            guard let statBoard = parent.originAnchor.findEntity(named: "Metrics") else {
                return
            }
            
            self.removeEntityAnimated(statBoard)
            self.addMetricBoard()
        }
    }
    
    func returnTile(entity: Entity?, column: Int, row: Int) {
        guard let entityToReturn = parent.originAnchor.findEntity(named: "GridSquare-\(column)-\(row)") else {
            return
        }
        
        self.removeEntityAnimated(entityToReturn)
        
        let movePosition: SIMD3<Float> = [
            parent.originAnchor.position.x + Float((12 + 1) * (column - 3)) / 100.0,
            parent.originAnchor.position.y,
            parent.originAnchor.position.z + Float((12 + 1) * (row - 3)) / 100.0
        ]
        
        self.grid.gridTiles.fetch(col: column, row: row)?.placeSquare(view: parent.view, originAnchor: parent.originAnchor)
        
        /*
        let currentTilePosition = entityToReturn.position(relativeTo: parent.originAnchor)
        
        let moveTransformAmount: SIMD3<Float> = currentTilePosition - movePosition
        
        let moveTransform: Transform = Transform(translation: moveTransformAmount)
        entityToReturn.move(to: moveTransform, relativeTo: entityToReturn, duration: 0.3)*/
    }
    
    @MainActor 
    func addMainIntroView() {
        let mainIntroPosition: SIMD3<Float> = [
            parent.originAnchor.position.x,
            parent.originAnchor.position.y + 0.4,
            parent.originAnchor.position.z - 0.05
        ]
        
        let mainIntroWrapper = ARRealityKitSwiftUIView(anchorTitle: "MainIntro") {
            InitialPromptView()
        }
        
        mainIntroWrapper.addView(arView: parent.view, baseAnchor: parent.originAnchor, position: mainIntroPosition)
    }
    
    @MainActor 
    func addDescriptorViews() {
        // Add Agriculture Descriptor
        let agricultureDescriptorPosition: SIMD3<Float> = [
            parent.originAnchor.position.x + (12 * 3 + 3 * 1) / 100.0,
            parent.originAnchor.position.y + 0.6,
            parent.originAnchor.position.z + (12 * 2 + 3 * 1) / 100.0
        ]
        
        let agricultureDescriptorWrapper = ARRealityKitSwiftUIView(anchorTitle: "Descriptor-Agriculture") {
            AgricultureTileDescriptor()
        }
        agricultureDescriptorWrapper.addView(arView: parent.view, baseAnchor: parent.originAnchor, position: agricultureDescriptorPosition)
        
        // Add Carbon Capture Descriptor
        let carbonDescriptorPosition: SIMD3<Float> = [
            parent.originAnchor.position.x + 0.5,
            parent.originAnchor.position.y + 0.8,
            parent.originAnchor.position.z
        ]
        
        let carbonDescriptorWrapper = ARRealityKitSwiftUIView(anchorTitle: "Descriptor-CarbonCapture") {
            CarbonCaptureTileDescriptor()
        }
        carbonDescriptorWrapper.addView(arView: parent.view, baseAnchor: parent.originAnchor, position: carbonDescriptorPosition)
        
        // Add Industry Descriptor
        let industryDescriptorPosition: SIMD3<Float> = [
            parent.originAnchor.position.x - 0.5,
            parent.originAnchor.position.y + 0.8,
            parent.originAnchor.position.z
        ]
        
        let industryDescriptorWrapper = ARRealityKitSwiftUIView(anchorTitle: "Descriptor-Industry") {
            IndustryTileDescriptor()
        }
        industryDescriptorWrapper.addView(arView: parent.view, baseAnchor: parent.originAnchor, position: industryDescriptorPosition)
        
        // Add Plain Descriptor
        let plainDescriptorPosition: SIMD3<Float> = [
            parent.originAnchor.position.x - (12 * 2 + 1 * 2) / 100.0,
            parent.originAnchor.position.y + 0.5,
            parent.originAnchor.position.z
        ]
        
        let plainDescriptorWrapper = ARRealityKitSwiftUIView(anchorTitle: "Descriptor-Plain") {
            PlainTileDescriptor()
        }
        plainDescriptorWrapper.addView(arView: parent.view, baseAnchor: parent.originAnchor, position: plainDescriptorPosition)
        
        // Add Poor Population Descriptor
        let poorPopulationDescriptorPosition: SIMD3<Float> = [
            parent.originAnchor.position.x - (12 * 2 + 1 * 2) / 100.0,
            parent.originAnchor.position.y + 0.5,
            parent.originAnchor.position.z + (12 * 2 + 1 * 2) / 100.0
        ]
        
        let poorPopulationDescriptorWrapper = ARRealityKitSwiftUIView(anchorTitle: "Descriptor-PoorPopulation") {
            PoorPopulationTileDescriptor()
        }
        poorPopulationDescriptorWrapper.addView(arView: parent.view, baseAnchor: parent.originAnchor, position: poorPopulationDescriptorPosition)
        
        // Add Rich Population Descriptor
        let richPopulationDescriptorPosition: SIMD3<Float> = [
            parent.originAnchor.position.x + (12 * 3 + 1 * 3) / 100.0,
            parent.originAnchor.position.y + 0.5,
            parent.originAnchor.position.z + (12 * 3 + 1 * 3) / 100.0
        ]
        
        let richPopulationDescriptorWrapper = ARRealityKitSwiftUIView(anchorTitle: "Descriptor-RichPopulation") {
            RichPopulationTileDescriptor()
        }
        richPopulationDescriptorWrapper.addView(arView: parent.view, baseAnchor: parent.originAnchor, position: richPopulationDescriptorPosition)
        
        // Add Forest Descriptor
        let forestDescriptorPosition: SIMD3<Float> = [
            parent.originAnchor.position.x,
            parent.originAnchor.position.y + 0.8,
            parent.originAnchor.position.z - (12 * 3 + 1 * 3) / 100.0
        ]
        
        let forestDescriptorWrapper = ARRealityKitSwiftUIView(anchorTitle: "Descriptor-Forest") {
            TreeTileDescriptor()
        }
        forestDescriptorWrapper.addView(arView: parent.view, baseAnchor: parent.originAnchor, position: forestDescriptorPosition)
        
        // Add Water Descriptor
        let waterDescriptorPosition: SIMD3<Float> = [
            parent.originAnchor.position.x - (12 * 3 + 1 * 3) / 100.0,
            parent.originAnchor.position.y + 0.4,
            parent.originAnchor.position.z - (12 * 3 + 1 * 3) / 100.0
        ]
        
        let waterDescriptorWrapper = ARRealityKitSwiftUIView(anchorTitle: "Descriptor-Water") {
            WaterTileDescriptor()
        }
        waterDescriptorWrapper.addView(arView: parent.view, baseAnchor: parent.originAnchor, position: waterDescriptorPosition)
    }
    
    @MainActor 
    func addYear(_ count: Int) {
        // Add year within the grid model
        let tilesToUpdate = grid.ageUp(count)
        
        // Change grid tiles that have changed within the model
        for (location, newType) in tilesToUpdate {
            guard let gridEntity = parent.originAnchor.findEntity(named: "GridSquare-\(location.column)-\(location.row)") else {
                continue
            }
            
            let currentPosition = gridEntity.position
            self.removeEntityAnimated(gridEntity)
            
            guard let newModelEntity = newType.asModelEntity(
                column: location.column, row: location.row, elevation: location.elevation) else {
                continue
            }
            
            newModelEntity.setPosition(currentPosition, relativeTo: nil)
            newModelEntity.name = "GridSquare-\(location.column)-\(location.row)"
            newModelEntity.generateCollisionShapes(recursive: true)
            
            parent.originAnchor.addChild(newModelEntity)
        }
        
        //Re-render stat board
        
        guard let statBoard = parent.originAnchor.findEntity(named: "Metrics") else {
            return
        }
        
        self.removeEntityAnimated(statBoard)
        self.addMetricBoard()
    }
    
    func removeEntityAnimated(_ entity: Entity) {
        var scaleTransform: Transform = Transform()
        scaleTransform.scale = [0.0, 0.0, 0.0]
        
        entity.move(to: entity.transform, relativeTo: entity.parent)
        entity.move(to: scaleTransform, relativeTo: entity, duration: 0.3)
        
        entity.removeFromParent()
    }
    
    func removeEntityAnimated(name: String) {
        guard let entityToRemove = parent.view.scene.findEntity(named: name) else {
            return
        }
        
        var scaleTransform: Transform = Transform()
        scaleTransform.scale = [0.0, 0.0, 0.0]
        
        entityToRemove.move(to: entityToRemove.transform, relativeTo: entityToRemove.parent)
        entityToRemove.move(to: scaleTransform, relativeTo: entityToRemove, duration: 0.3)
        
        entityToRemove.removeFromParent()
    }
    
    func removeFullWindow() {
        self.removeEntityAnimated(name: "Window-Selector-Base")
        self.removeEntityAnimated(name: "Window-Selector-Title")
        
        self.removeEntityAnimated(name: "Selector-Agriculture")
        self.removeEntityAnimated(name: "Selector-CarbonCapture")
        self.removeEntityAnimated(name: "Selector-Industry")
        self.removeEntityAnimated(name: "Selector-Plain")
        self.removeEntityAnimated(name: "Selector-Home")
        self.removeEntityAnimated(name: "Selector-Tree")
        
        self.removeEntityAnimated(name: "SelectorAction-Cancel")
        self.removeEntityAnimated(name: "SelectorAction-Select")
    }
    
    func updateWaterEntity(from: WaterLevel, to: WaterLevel) {
        // No need to rerender if the water remains the same height
        if from == to { return }
        
        // Get the water entity within the scene
        guard let waterEntity = parent.originAnchor.findEntity(named: "Water") else {
            return
        }
        
        // Remove that water entity
        waterEntity.removeFromParent()
        
        // Add new water entity with adjusted height
        ARWater.addToView(arView: parent.view, baseAnchor: parent.originAnchor, waterLevel: to, relativePosition: nil)
    }
    
    @MainActor
    func addGameOverView(reason: Grid.GameOverTypes) {
        let gameOverPosition: SIMD3<Float> = [
            parent.originAnchor.position.x,
            parent.originAnchor.position.y + 0.6,
            parent.originAnchor.position.z
        ]
        
        let gameOverConverter = ARRealityKitSwiftUIView(anchorTitle: "GameOver") {
            GameOverView(width: 400, gameOverState: reason)
        }
        
        gameOverConverter.addView(arView: parent.view, baseAnchor: parent.originAnchor, position: gameOverPosition)
    }
    
    @MainActor 
    func addMetricBoard() {
        let metricPosition: SIMD3<Float> = [
            parent.originAnchor.position.x,
            parent.originAnchor.position.y + 0.5,
            parent.originAnchor.position.z - (12 * 3 + 1 * 3 + 6 + 6) / 100.0
        ]
        
        let metricsHandler = ARRealityKitSwiftUIView(anchorTitle: "Metrics") {
            MainMetricsDashboardViewComponent(
                currentYear: self.grid.currentYear,
                moneyLevel: self.grid.moneyLevel,
                temperatureLevel: self.grid.pollutionLevel,
                happinessLevel: self.grid.happinessLevel
            )
        }
        
        metricsHandler.addView(arView: parent.view, baseAnchor: parent.originAnchor, position: metricPosition)
    }
    
    func buildWorld() {
        // Place the world
        grid.placeGrid(view: parent.view, originAnchor: parent.originAnchor)
        
        // Place the water
        ARWater.addToView(arView: parent.view, baseAnchor: parent.originAnchor, waterLevel: .level0, relativePosition: nil)
    }
    
    func addButtons() {
        let add1YearPosition: SIMD3<Float> = [
            parent.originAnchor.position.x - 0.3,
            parent.originAnchor.position.y,
            parent.originAnchor.position.z + (12 * 3 + 1 * 3 + 6 + 18) / 100.0
        ]
        ARAdd1YearButton.addToView(arView: parent.view, baseAnchor: parent.originAnchor, relativePosition: add1YearPosition)
        
        let add5YearPosition: SIMD3<Float> = [
            parent.originAnchor.position.x,
            parent.originAnchor.position.y,
            parent.originAnchor.position.z + (12 * 3 + 1 * 3 + 6 + 18) / 100.0
        ]
        ARAdd5YearsButton.addToView(arView: parent.view, baseAnchor: parent.originAnchor, relativePosition: add5YearPosition)
        
        let add30YearPosition: SIMD3<Float> = [
            parent.originAnchor.position.x + 0.3,
            parent.originAnchor.position.y,
            parent.originAnchor.position.z + (12 * 3 + 1 * 3 + 6 + 18) / 100.0
        ]
        ARAdd30YearsButton.addToView(arView: parent.view, baseAnchor: parent.originAnchor, relativePosition: add30YearPosition)
    }
    
    @MainActor 
    func addButtonDescriptions() {
        let buttonDescriptionPosition: SIMD3<Float> = [
            parent.originAnchor.position.x,
            parent.originAnchor.position.y + 0.3,
            parent.originAnchor.position.z + (12 * 3 + 1 * 3 + 6 + 12) / 100.0
        ]
        
        let buttonDescriptionWrapper = ARRealityKitSwiftUIView(anchorTitle: "ButtonDescription") {
            AddYearButtonDescriptionsView()
        }
        
        buttonDescriptionWrapper.addView(arView: parent.view, baseAnchor: parent.originAnchor, position: buttonDescriptionPosition)
    }
    
    @MainActor
    func addNoMoneyView() {
        let descriptionPosition: SIMD3<Float> = [
            parent.originAnchor.position.x,
            parent.originAnchor.position.y + 0.3,
            parent.originAnchor.position.z + (12 * 3 + 1 * 3 + 6 + 12) / 100.0
        ]
        
        let alertWrapper = ARRealityKitSwiftUIView(anchorTitle: "NoMoney") {
            NoMoneyAlertView(width: 400)
        }
        
        alertWrapper.addView(arView: parent.view, baseAnchor: parent.originAnchor, position: descriptionPosition)
    }
}

extension Int {
    init(_ value: String.SubSequence) {
        let stringedSequence = String(value)
        
        do {
            try self.init(stringedSequence, format: .number)
        } catch {
            self.init(0)
        }
    }
}

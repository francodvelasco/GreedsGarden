//
//  TileSelectorViewComponent.swift
//  
//
//  Created by Franco Velasco on 1/25/24.
//

import SwiftUI

struct TileSelectorViewComponent: View {
    
    // plain, agriculture, trees(TreeStage), industry, population, carbon_capture, water(WaterLevel)
    var body: some View {
        EqualWidthLayout {
            ZStack(alignment: .bottomTrailing) {
                Rectangle()
                    .fill(Color.yellow)
                    .frame(width: 160, height: 128)
                Text("Agriculture")
                    .padding(8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .onTapGesture {
                //
            }
            
            ZStack(alignment: .bottomTrailing) {
                Rectangle()
                    .fill(Color.yellow)
                    .frame(width: 160, height: 128)
                Text("Tree")
                    .padding(8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .onTapGesture {
                //
            }
            
            ZStack(alignment: .bottomTrailing) {
                Rectangle()
                    .fill(Color.yellow)
                    .frame(width: 160, height: 128)
                Text("Industry")
                    .padding(8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .onTapGesture {
                //
            }
            
            ZStack(alignment: .bottomTrailing) {
                Rectangle()
                    .fill(Color.yellow)
                    .frame(width: 160, height: 128)
                Text("People")
                    .padding(8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .onTapGesture {
                //
            }
            
            ZStack(alignment: .bottomTrailing) {
                Rectangle()
                    .fill(Color.yellow)
                    .frame(width: 160, height: 128)
                Text("Carbon Capture")
                    .padding(8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .onTapGesture {
                
            }
        }
    }
}

#Preview {
    TileSelectorViewComponent()
}

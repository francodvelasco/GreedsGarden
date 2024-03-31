//
//  CarbonCaptureTileDescriptor.swift
//  
//
//  Created by Franco Velasco on 2/10/24.
//

import SwiftUI

struct CarbonCaptureTileDescriptor: View {
    var body: some View {
        HStack {
            /*ModelTemplateView(modelType: .carbon_capture)
                .frame(width: 200, height: 200)
                .padding(.horizontal)*/
            VStack {
                Text("Carbon Capture Plant")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Forests take a long time to grow, so build one of these and **start removing pollution much faster.** It won't suck as much as a fully-grown forest though, but them's the breaks.")
                    .multilineTextAlignment(.center)
                Text("Tap to Dismiss...")
                    .font(.callout)
            }
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .frame(width: 400)
    }
}

#Preview {
    CarbonCaptureTileDescriptor()
}

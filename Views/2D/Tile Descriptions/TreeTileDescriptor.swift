//
//  TreeTileDescriptor.swift
//  
//
//  Created by Franco Velasco on 2/10/24.
//

import SwiftUI

struct TreeTileDescriptor: View {
    var body: some View {
        HStack {
            /*ModelTemplateView(modelType: .trees(.grown))
                .frame(width: 200, height: 200)
                .padding(.horizontal)*/
            VStack(alignment: .center) {
                Text("Forest")
                    .font(.title)
                    .fontWeight(.bold)
                Text("The best way to **clear out pollution** in the atmosphere. Takes some time to fully grow out though, with some **30 years needed for the forest** to become the best carbon sink it can be.")
                    .multilineTextAlignment(.center)
                Text("Tap to Dismiss...")
                    .font(.callout)
            }
        }
        .padding()
        .background(Color.white)
        .frame(width: 400)
    }
}

#Preview {
    TreeTileDescriptor()
}

//
//  PoorPopulationTileDescriptor.swift
//  
//
//  Created by Franco Velasco on 2/10/24.
//

import SwiftUI

struct PoorPopulationTileDescriptor: View {
    var body: some View {
        HStack {
            /*ModelTemplateView(modelType: .population(.poor))
                .frame(width: 200, height: 200)
                .padding(.horizontal)*/
            VStack {
                Text("Poor Population")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Everyone has their humble beginnings. They appreciate the simple life more in agriculture over industry. Help them out, then **they'll work their way up to become rich.**")
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
    PoorPopulationTileDescriptor()
}

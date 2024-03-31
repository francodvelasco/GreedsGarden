//
//  AgricultureTileDescriptor.swift
//  
//
//  Created by Franco Velasco on 2/10/24.
//

import SwiftUI

struct AgricultureTileDescriptor: View {
    var body: some View {
        HStack {
            /*ModelTemplateView(modelType: .agriculture)
                .frame(width: 200, height: 200)
                .padding(.horizontal)*/
            VStack(alignment: .center) {
                Text("Agriculture")
                    .font(.title)
                    .fontWeight(.bold)
                Text("**Essential to feed your people.** The crops absorb some pollution, but not as much as trees or carbon capture plants. Poorer people will be happy to work with this.")
                    .multilineTextAlignment(.center)
                Text("Tap to Dismiss...")
                    .font(.callout)
            }
        }
        .padding()
        .background(Color.yellow)
        .frame(width: 400)
    }
}

#Preview {
    AgricultureTileDescriptor()
}

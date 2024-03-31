//
//  RichPopulationTileDescriptor.swift
//  
//
//  Created by Franco Velasco on 2/10/24.
//

import SwiftUI

struct RichPopulationTileDescriptor: View {
    var body: some View {
        HStack {
            /*ModelTemplateView(modelType: .population(.rich))
                .frame(width: 200, height: 200)
                .padding(.horizontal)*/
            VStack(alignment: .center) {
                Text("Rich Population")
                    .font(.title)
                    .fontWeight(.bold)
                Text("More money does cause more problems. Richer people will **demand even more industries** to maximize their money.")
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
    RichPopulationTileDescriptor()
}

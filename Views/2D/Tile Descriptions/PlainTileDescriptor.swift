//
//  PlainTileDescriptor.swift
//  
//
//  Created by Franco Velasco on 2/10/24.
//

import SwiftUI

struct PlainTileDescriptor: View {
    var body: some View {
        HStack {
            /*ModelTemplateView(modelType: .plain)
                .frame(width: 200, height: 200)
                .padding(.horizontal)*/
            VStack(alignment: .center) {
                Text("Plain")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Just a plain plot of land. Build anything to your heart's content.")
                    .multilineTextAlignment(.center)
                Text("Tap to Dismiss...")
                    .font(.callout)
            }
        }
        .padding()
        .background(Color.green)
        .foregroundColor(.white)
        .frame(width: 400)
    }
}

#Preview {
    PlainTileDescriptor()
}

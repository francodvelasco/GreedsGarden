//
//  IndustryTileDescriptor.swift
//
//
//  Created by Franco Velasco on 2/10/24.
//

import SwiftUI

struct IndustryTileDescriptor: View {
    var body: some View {
        HStack {
            /*ModelTemplateView(modelType: .industry)
                .frame(width: 200, height: 200)
                .padding(.horizontal)*/
            VStack {
                Text("Industry")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Earn lots of money easily. In exchange for **quite a bit of pollution, your population will become happier** with all the jobs and products they'll get to have.")
                    .multilineTextAlignment(.center)
                Text("Tap to Dismiss...")
                    .font(.callout)
            }
        }
        .padding()
        .background(Color.brown)
        .foregroundColor(.white)
        .frame(width: 400)
    }
}

#Preview {
    IndustryTileDescriptor()
}

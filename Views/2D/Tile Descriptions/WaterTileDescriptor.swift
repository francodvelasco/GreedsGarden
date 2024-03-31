//
//  WaterTileDescriptor.swift
//  
//
//  Created by Franco Velasco on 2/11/24.
//

import SwiftUI

struct WaterTileDescriptor: View {
    var body: some View {
        HStack {
            VStack(alignment: .center) {
                Text("Water")
                    .font(.title)
                    .fontWeight(.bold)
                Text("You can't build anything on it, but watch out when your air gets polluted: **some far away ice will melt by the rise in temperatures, possibly causing the water level to rise.**")
                    .multilineTextAlignment(.center)
                Text("Tap to Dismiss...")
                    .font(.callout)
            }
        }
        .padding()
        .background(Color.cyan)
        .frame(width: 400)
    }
}

#Preview {
    WaterTileDescriptor()
}

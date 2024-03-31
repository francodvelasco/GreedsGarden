//
//  StartingView.swift
//  
//
//  Created by Franco Velasco on 1/20/24.
//

import SwiftUI

struct StartingView: View {
    var body: some View {
        // 1. Employ ContainerRelativeShape for corner radius matching:
        ZStack {
            CameraBackgroundView()
            // 2. Inset the content with padding:
            ContainerRelativeShape()
                .inset(by: 32) // Adjust padding as needed
                .fill(.thickMaterial.opacity(0.85)) // Apply background color
                .overlay(
                    HStack {
                        VStack(alignment: .leading) {
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Welcome to")
                                    .font(.system(size: 32, weight: .regular))
                                Text("Greed's Garden")
                                    .font(.system(size: 64, weight: .semibold))
                            }
                            Spacer()
                            Text("Find the true roots of our Climate Crisis.")
                                .font(.system(size: 32, weight: .regular))
                            Spacer()
                            HStack {
                                Text("Tap to Continue")
                                Image(systemName: "arrow.forward")
                            }
                            .font(.system(size: 24, weight: .regular))
                        }
                        Spacer()
                        Rectangle()
                            .frame(width: 400, height: 400)
                    }
                    .padding(64) // Optional content padding
                )
            
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    StartingView()
}

//
//  IntroView.swift
//  
//
//  Created by Franco Velasco on 2/14/24.
//

import SwiftUI

struct IntroView: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Welcome to")
                .font(.system(size: 16, weight: .regular))
            Text("Greed's Garden")
                .font(.system(size: 32, weight: .semibold))
            Spacer()
            //ModelTemplateView(modelType: .agriculture)
              //  .frame(width: 100, height: 100)
            Spacer()
            Text("Find the true roots of our Climate Crisis.")
                .font(.system(size: 12, weight: .regular))
            Spacer()
            Text("Tap to Continue...")
                .font(.system(size: 8, weight: .regular))
        }
        .padding(8)
        .frame(width: 300, height: 200)
        .background(Color.white)
    }
}

#Preview {
    IntroView()
}

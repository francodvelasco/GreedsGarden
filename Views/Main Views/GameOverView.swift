//
//  GameOverView.swift
//  
//
//  Created by Franco Velasco on 2/14/24.
//

import SwiftUI

struct GameOverView: View {
    var width: CGFloat?
    var height: CGFloat?
    var gameOverState: Grid.GameOverTypes
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Game Over! 💔")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom)
            Text("\(gameOverState.reasonText) Notice how hard it is to balance the demands of the people with the environment? It's easier for people to adjust to the needs of the environment that the other way around.")
                .multilineTextAlignment(.center)
                .padding(.bottom)
            Text("If we want to stop any climate crisis, **we need to stop our greed.**")
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.white)
        .frame(width: width, height: height)
    }
}

#Preview {
    GameOverView(width: 400, height: 300, gameOverState: .NoMoney)
}

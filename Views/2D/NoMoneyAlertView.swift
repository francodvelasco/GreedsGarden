//
//  SwiftUIView.swift
//  
//
//  Created by Franco Velasco on 2/26/24.
//

import SwiftUI

struct NoMoneyAlertView: View {
    var width: CGFloat?
    var height: CGFloat?
    
    var body: some View {
        VStack(alignment: .center) {
            Text("You can't build that!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom)
            Text("You don't have enough money to build that. Earn more money in later years, then try again.")
                .multilineTextAlignment(.center)
                .padding(.bottom)
            Text("Tap to Dismiss")
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.white)
        .frame(width: width, height: height)
    }
}

#Preview {
    VStack {
        Text("Agriculture")
            .fontWeight(.medium)
        Spacer()
    }
    .padding(8)
    .background(Color.white)
}

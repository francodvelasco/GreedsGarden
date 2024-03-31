//
//  InitialPromptView.swift
//  
//
//  Created by Franco Velasco on 2/19/24.
//

import SwiftUI

struct InitialPromptView: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("Hello. You're the government now. Your job is to **make this grid the best it could be.**")
                .multilineTextAlignment(.center)
                .padding(.bottom, 4)
            Text("Balance the needs of the population, the wealth of the land, and the pollution in the air. Develop each tile of the land by tapping on it and choosing the replacement you want to add to your land.")
                .multilineTextAlignment(.center)
                .padding(.bottom, 4)
            Text("**Close this dialog by tapping** on it and see what types of tiles you can place.")
                .multilineTextAlignment(.center)
                .padding(.bottom, 4)
            Spacer()
        }
        .font(.system(size: 16))
        .padding(8)
        .frame(width: 400, height: 300)
        .background(Color.white)
    }
}

#Preview {
    InitialPromptView()
}

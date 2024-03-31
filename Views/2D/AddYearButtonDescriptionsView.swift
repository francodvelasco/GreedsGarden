//
//  AddYearButtonDescriptionsView.swift
//  
//
//  Created by Franco Velasco on 2/18/24.
//

import SwiftUI

struct AddYearButtonDescriptionsView: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("Your goal is to **make your land last as long as possible, by balancing its money, pollution and happiness.** To go through time, tap on the buttons below.")
                .multilineTextAlignment(.center)
                .padding(.bottom, 4)
            Text("Add 1 year to progress your grid a bit. Add 5 years to skip to when your new industrial factory or carbon capture plant is working. Add 30 years to fully grow out a forest.")
                .multilineTextAlignment(.center)
                .padding(.bottom, 4)
            Text("Got it? Good. **Tap this window to close it and start developing your land!**")
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(8)
        .frame(width: 400)
        .background(Color.white)
    }
}

#Preview {
    AddYearButtonDescriptionsView()
}

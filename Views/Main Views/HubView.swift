//
//  HubView.swift
//  
//
//  Created by Franco Velasco on 1/24/24.
//

import SwiftUI

struct HubView: View {
    var body: some View {
        ZStack {
            Color.green
            
            Rectangle()
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(16)
                
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    HubView()
}

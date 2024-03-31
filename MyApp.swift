import SwiftUI

@main
struct MyApp: App {
    @State var loadingText: String = ""
    @State var isLoading: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ARHubView(isLoading: $isLoading, loadingText: $loadingText)
                    .ignoresSafeArea()
                
                if isLoading {
                    VStack {
                        Spacer()
                        Text(loadingText)
                            .font(.callout)
                            .padding(.bottom, 8)
                    }
                }
            }
        }
    }
}

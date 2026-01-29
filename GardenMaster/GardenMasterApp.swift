import SwiftUI

@main
struct GardenMasterApp: App {
    @StateObject private var appState = AppState()
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation(.easeOut(duration: 0.5)) {
                                showSplash = false
                            }
                        }
                    }
            } else {
                MainTabView()
                    .environmentObject(appState)
                    .preferredColorScheme(.dark)
            }
        }
    }
}

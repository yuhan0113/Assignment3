import SwiftUI

@main
struct Assignment_3App: App {
    @StateObject private var userSettings = UserSettings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userSettings)
        }
    }
}

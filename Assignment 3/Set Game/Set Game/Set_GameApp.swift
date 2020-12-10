import SwiftUI

@main
struct Set_GameApp: App {
    let game = SetGame()
    var body: some Scene {
        WindowGroup {
            SetGameView(viewModel: game)
        }
    }
}

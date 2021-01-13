import SwiftUI

@main
struct MemorizeApp: App {
    let store = EmojiMemoryGameStore(named: "Emoji Memory Game")
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameChooser().environmentObject(store)
        }
    }
}

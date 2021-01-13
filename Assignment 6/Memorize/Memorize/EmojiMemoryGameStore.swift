import SwiftUI
import Combine

class EmojiMemoryGameStore: ObservableObject {
    let name: String
    
    func removeTheme(_ theme: Theme) {
        for (themeIndex, themeInstance) in themes.enumerated() {
            if theme == themeInstance {
                themes.remove(at: themeIndex)
            }
        }
    }
    
    func addTheme(theme: Theme) {
        themes.append(theme)
    }
    
    @Published var themes = [Theme]()
    
    private var autosave: AnyCancellable?
    
    init(named name: String = "Memory Game") {
        self.name = name
        let defaultsKey = "EmojiMemoryGameStore.\(name)"
        if let savedThemes = UserDefaults.standard.object(forKey: defaultsKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedThemes = try? decoder.decode([Theme].self, from: savedThemes) {
                themes = loadedThemes
            }
        }
        autosave = $themes.sink { themesList in
            let encoder = JSONEncoder()
            if let encodedThemes = try? encoder.encode(themesList) {
                UserDefaults.standard.setValue(encodedThemes, forKey: defaultsKey)
            }
        }
    }
}

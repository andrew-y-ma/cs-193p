import SwiftUI

func createCardcontent(pairIndex: Int) -> String {
    return "😁"
}

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame(theme: themes[Int.random(in: 0..<themes.count)])
    
    private static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        let pairsOfCards = theme.noOfPairs ?? Int.random(in: 3...theme.emojis.count)
        return MemoryGame<String>(numberOfPairsOfCards: pairsOfCards, theme: theme) {pairIndex in
            return theme.emojis[pairIndex]
        }

    }
    // MARK: - Access to the Model
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    var theme: Theme {
        model.theme
    }
    
    var gradient: LinearGradient? {
        LinearGradient(gradient: Gradient(colors: [theme.color, theme.accentColor]), startPoint: .top, endPoint: .bottom)
    }
    
    // MARK: - Intent(s)
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func refreshGame() {
        model = EmojiMemoryGame.createMemoryGame(theme: themes[Int.random(in: 0..<themes.count)])
    }
}

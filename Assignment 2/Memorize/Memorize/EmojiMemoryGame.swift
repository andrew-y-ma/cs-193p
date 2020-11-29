import SwiftUI

func createCardcontent(pairIndex: Int) -> String {
    return "😁"
}

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame(theme: themes[Int.random(in: 0..<themes.count)])
    
    static var theme: Theme?
    
    static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
//        var emojis = ["👻", "🎃", "🕷", "🕸", "🧙‍♂️"]
        
//        theme.emojis = theme.emojis.shuffled()
        self.theme = theme
        return MemoryGame<String>(numberOfPairsOfCards: Int.random(in: 3...theme.emojis.count)) {pairIndex in
            return theme.emojis[pairIndex]
        }

    }
    // MARK: - Access to the Model
    
    func refreshGame() {
        model = EmojiMemoryGame.createMemoryGame(theme: themes[Int.random(in: 0..<themes.count)])
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
//        return model.cards
//        model.cards // one line in closure or functional will automatically that line
    }
    
    var score: Int {
        get {
            model.score
        }
        set {
            model.score = newValue
        }
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
//        card.isFaceUp = !card.isFaceUp
    }
}

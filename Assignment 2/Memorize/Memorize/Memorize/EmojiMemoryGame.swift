import SwiftUI

func createCardcontent(pairIndex: Int) -> String {
    return "😁"
}

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame(theme: themes[Int.random(in: 0..<themes.count)])
    
    static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        let pairsOfCards = theme.noOfPairs ?? Int.random(in: 3...theme.emojis.count)
        return MemoryGame<String>(numberOfPairsOfCards: pairsOfCards, theme: theme) {pairIndex in
            return theme.emojis[pairIndex]
        }

    }
    // MARK: - Access to the Model
    func refreshGame() {
        model = EmojiMemoryGame.createMemoryGame(theme: themes[Int.random(in: 0..<themes.count)])
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    var score: Int {
        get {
            model.score
        }
        set {
            model.score = newValue
        }
    }
    
    var theme: Theme {
        get {
            model.theme
        }
    }
    
    var gradient: LinearGradient? {
        get {
            LinearGradient(gradient: Gradient(colors: [theme.color, theme.accentColor]), startPoint: .top, endPoint: .bottom)
        }
    }
    
    // MARK: - Intent(s)
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
}
//
//extension CAGradientLayer: ShapeStyle{
//    public static func _makeView<S>(view: _GraphValue<_ShapeView<S, CAGradientLayer>>, inputs: _ViewInputs) -> _ViewOutputs where S : Shape {
//
//    }
//
//
//}

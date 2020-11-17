import SwiftUI

func createCardcontent(pairIndex: Int) -> String {
    return "😁"
}

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["👻", "🎃", "🕷", "🕸", "🧙‍♂️"]

        return MemoryGame<String>(numberOfPairsOfCards: Int.random(in: 2...5)) {pairIndex in
            return emojis[pairIndex]
        }

    }
    // MARK: - Access to the Model
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards.shuffle()
        return model.cards
//        model.cards // one line in closure or functional will automatically that line
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
//        card.isFaceUp = !card.isFaceUp
    }
}

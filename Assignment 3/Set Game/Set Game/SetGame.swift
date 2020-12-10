import SwiftUI

class SetGame: ObservableObject {
    @Published private var model: CardGame = SetGame.createSetGame()
    
    private static func createSetGame() -> CardGame {
        let colours: [Color] = [.blue, .red, .green]
        let occurrences = [1, 2, 3]
        let opacities = [0, 0.50, 1]
        return CardGame(colours: colours, opacities: opacities, occurrences: occurrences)
    }
    
    var cards: Array<CardGame.Card> {
        return model.cards
    }
    
    var cardsInHand: Array<CardGame.Card> {
        return model.cardsInHand
    }
    
    //MARK: - Intents
    func choose(card: CardGame.Card) {
        model.choose(card: card)
        print(card)
    }
    
    func dealThreeCards() {
        model.dealNumberOfCards(3)
    }
    
    func refreshGame() {
        model = SetGame.createSetGame()
    }
    
}

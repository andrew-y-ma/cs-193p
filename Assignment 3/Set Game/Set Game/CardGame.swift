import SwiftUI

struct CardGame/*<CardContent> where CardContent: Equatable */ {
    private(set) var cards: Array<Card>
    var cardsInHand: Array<Card> {
        cards.filter({$0.isDealt && !$0.wasMatched})
    }
    
    var cardsInDeck: Array<Card> {
        cards.filter({!$0.isDealt})
    }
    
    enum Shape: String, CaseIterable {
        case rectangle
        case pill
        case diamond
    }
    
    private var indicesOfFaceUpCards: [Int]? {
        get { cards.indices.filter{cards[$0].isFaceUp} }
        set {
            if newValue != nil {
                for index in cards.indices {
                    cards[index].isFaceUp = newValue!.contains(index)
                }
            }
        }
    }
    
    init(colours: [Color], opacities: [Double], occurrences: [Int]) {
        // initialize new set game
        var i = 0
        cards = []
        
        for colour in colours {
            for opacity in opacities {
                for occurrence in occurrences {
                    for shape in Shape.allCases {
                        cards.append(Card(id: i, opacity: opacity, shapeOcurrences: occurrence, colour: colour, shape: shape))
                        i += 1
                    }
                }
            }
        }
        cards.shuffle()
        for cardIndex in 0..<12 {
            cards[cardIndex].isDealt = true
        }
    }
    
    mutating func dealNumberOfCards(_ number: Int) {
        if let firstFaceUpIndex = indicesOfFaceUpCards?.first {
            if cards[firstFaceUpIndex].isMatched {
                for index in indicesOfFaceUpCards! {
                    cards[index].wasMatched = true
                    cards[index].isFaceUp = false
                }
            }
        }
        
        for _ in 0..<number {
            var notInDeck = true
            var index = 0
            while notInDeck && index < cards.count {
                if !cards[index].isDealt {
                    notInDeck = false
                    cards[index].isDealt = true
                }
                index += 1
            }
        }
    }
    
    mutating func choose(card: Card) {
        if let chosenIndex: Int = cards.firstIndex(matching: card) {
            if var potentialMatchIndices = indicesOfFaceUpCards {
                if potentialMatchIndices.contains(chosenIndex) && potentialMatchIndices.count != 3 {
                    cards[chosenIndex].isFaceUp = false
                } else if potentialMatchIndices.count == 2 {
                    //Check matching conditions then set cards to be matched if true, set to be unmatched and facedown otherwise
                    potentialMatchIndices.append(chosenIndex)
                    var setColour = false
                    var setOccurrences = false
                    var setShapes = false
                    var setOpacity = false
                    let faceUpCards = potentialMatchIndices.map{ cards[$0]}
                    
                    // check that each property is either all the same or all different
                    setColour = faceUpCards.dropFirst().allSatisfy{ $0.colour == faceUpCards.first!.colour } || Set(faceUpCards.map{$0.colour}).count == faceUpCards.count
                    setOccurrences = faceUpCards.dropFirst().allSatisfy{ $0.shapeOcurrences == faceUpCards.first!.shapeOcurrences } || Set(faceUpCards.map{$0.shapeOcurrences}).count == faceUpCards.count
                    setOpacity = faceUpCards.dropFirst().allSatisfy{ $0.opacity == faceUpCards.first!.opacity } || Set(faceUpCards.map{$0.opacity}).count == faceUpCards.count
                    setShapes = faceUpCards.dropFirst().allSatisfy{ $0.shape == faceUpCards.first!.shape } || Set(faceUpCards.map{$0.shape}).count == faceUpCards.count

                    if setColour && setOccurrences && setShapes && setOpacity {
                        for index in potentialMatchIndices {
                            cards[index].isMatched = true
                        }
                    } else {
                        for index in potentialMatchIndices {
                            cards[index].isNotMatched = true
                        }
                    }

                    cards[chosenIndex].isFaceUp = true
                } else if potentialMatchIndices.count == 3 {
                    print(potentialMatchIndices)
                    if cards[potentialMatchIndices[0]].isMatched && !potentialMatchIndices.contains(chosenIndex){
                        for index in potentialMatchIndices {
                            cards[index].wasMatched = true
                            cards[index].isFaceUp = false
                        }
                        dealNumberOfCards(3)
                        cards[chosenIndex].isFaceUp = true
                    } else {
                        for index in potentialMatchIndices {
                            cards[index].isFaceUp = false
                            cards[index].isNotMatched = false
                        }
                        cards[chosenIndex].isFaceUp = true
                    }
                } else {
                    cards[chosenIndex].isFaceUp = true
                }
                
            } else {
                indicesOfFaceUpCards = [chosenIndex]
            }
        }
    }
    
    private func clearCardsMatched(){
        
    }
    
    struct Card: Identifiable {
        var id: Int
        var isFaceUp = false
        var isMatched = false
        var isNotMatched = false
        var wasMatched = false
        var isDealt = false
        var opacity: Double
        var shapeOcurrences: Int
        var colour: Color
        var shape: Shape
    }
}

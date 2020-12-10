import SwiftUI

struct SetGameView: View {
    @ObservedObject var viewModel: SetGame
    
    var body: some View {
        VStack {
            Text("Set")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            Grid(viewModel.cardsInHand) { card in
                CardView(card: card).onTapGesture {
                    withAnimation(.linear(duration:0.75)) {
                        viewModel.choose(card: card)
                    }
                }
                .padding(2)
                .foregroundColor(Color.green)

            }
                .padding()
            
            HStack {
                Button("New Game", action: viewModel.refreshGame)
                Spacer()
                Button("Deal Cards", action: viewModel.dealThreeCards)
            }
            .padding(.leading, 40)
            .padding(.trailing, 40)
        }
    }
}

struct CardView: View {
    var card: CardGame.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(lineWidth: edgeLineWidth)
                        .fill(card.isMatched ? Color.green : Color.blue)
                        .animation(.easeIn)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(lineWidth: edgeLineWidth)
                        .fill(card.isNotMatched ? Color.red : Color.clear)
                        .animation(.easeIn)
                    VStack(spacing: 0) {
                        ForEach(0..<card.shapeOcurrences){_ in
                            ZStack {
                                if card.shape.rawValue == "pill" {
                                    RoundedRectangle(cornerRadius: pillRadius)
                                        .foregroundColor(card.colour)
                                        .opacity(card.opacity)
                                        .padding(geometry.size.width * 0.02)
                                    RoundedRectangle(cornerRadius: pillRadius)
                                        .stroke(lineWidth: shapeLineWidth).fill(card.colour)
                                        .padding(geometry.size.width * 0.02)

                                } else if card.shape.rawValue == "rectangle"{
                                    Rectangle()
                                        .foregroundColor(card.colour)
                                        .opacity(card.opacity)
                                        .padding(geometry.size.width * 0.02)
                                    Rectangle()
                                        .stroke(lineWidth: shapeLineWidth).fill(card.colour)
                                        .padding(geometry.size.width * 0.02)
                                } else {
                                    Circle()
                                        .foregroundColor(card.colour)
                                        .opacity(card.opacity)
                                        .padding(geometry.size.width * 0.02)
                                    Circle()
                                        .stroke(lineWidth: shapeLineWidth).fill(card.colour)
                                        .padding(geometry.size.width * 0.02)
                                }
                            }
                            .frame(width: geometry.size.width*0.50, height: geometry.size.height*0.15, alignment: .center)
                            .padding(0)
                        }
                    }
                } else {
                    if !card.isMatched && card.isDealt {
                        RoundedRectangle(cornerRadius: cornerRadius).fill(Color.blue)
                    }
                }
            }
                .font(Font.system(size: fontSize(for: geometry.size) * fontScaleFactor ))
                .aspectRatio(aspectRatio, contentMode: .fit)
            
        }
    }
    
    let cornerRadius: CGFloat = 10
    let pillRadius: CGFloat = 25
    let edgeLineWidth: CGFloat = 3
    let shapeLineWidth: CGFloat = 1
    let fontScaleFactor: CGFloat = 0.75
    let aspectRatio: CGFloat = 0.66
    
    
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.75
    }
}

struct SetGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGame()
        game.choose(card: game.cards[0])
        return SetGameView(viewModel: game)
    }
}

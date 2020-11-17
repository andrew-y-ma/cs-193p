import SwiftUI

struct EmojiMemoryGameView: View {
    //redraw every time objectwillchange.send() is called
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        return HStack() {
            ForEach(viewModel.cards) {card in
                CardView(card: card).onTapGesture { viewModel.choose(card: card)
                }
            }
            
        }
        .foregroundColor(.orange)
            .padding()
        
            
//        .font(.largeTitle)
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Spacer()
                ZStack{
                    if card.isFaceUp {
                        RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                        RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                        Text(card.content)
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadius).fill()
                    }
                }
                .font(Font.system(size: fontSize(for: geometry.size) * fontScaleFactor ))
                .aspectRatio(aspectRatio, contentMode: .fit)
                Spacer()
            }.frame(minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading)
        }
        
    }
    
    // MARK: - Drawing Constants
    
    let cornerRadius: CGFloat = 10
    let edgeLineWidth: CGFloat = 3
    let fontScaleFactor: CGFloat = 0.75
    let aspectRatio: CGFloat = 0.66
    
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.75
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}

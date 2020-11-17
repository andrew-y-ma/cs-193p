import SwiftUI

struct EmojiMemoryGameView: View {
    //redraw every time objectwillchange.send() is called
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        return HStack {
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
            ZStack{
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                    RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3.0)
                    Text(card.content)
                } else {
                    RoundedRectangle(cornerRadius: 10.0).fill()
                }
            }
            .font(Font.system(size: min(geometry.size.width, geometry.size.height) * 0.75 ))
            .aspectRatio(0.66, contentMode: .fit)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}

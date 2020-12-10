import SwiftUI

struct EmojiMemoryGameView: View {
    //redraw every time objectwillchange.send() is called
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            
            Text(viewModel.theme.name)
                .font(.title)
                .fontWeight(.bold)
                .padding()
            Grid(viewModel.cards) { card in
                CardView(card: card, gradient: viewModel.gradient!).onTapGesture {
                    withAnimation(.linear(duration:0.75)) {
                        viewModel.choose(card: card)
                    }
                }
                .padding(1.5)
                .foregroundColor(viewModel.theme.accentColor)

            }
                .padding()
            HStack {
                Text("Score: " + String(viewModel.score))
                    .padding()
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut(duration: 1)){
                        viewModel.refreshGame()
                    }
                }, label: { Text("New Game")})
                    .padding()
                    .foregroundColor(.black)
            }
                .padding()
        }
    }
    
    
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    var gradient: LinearGradient
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            if card.isFaceUp || !card.isMatched {
                ZStack{
                    Group {
                        if card.isConsumingBonusTime {
                            Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90), clockwise: true)
                                .onAppear{
                                    self.startBonusTimeAnimation()
                                }
                        } else {
                            Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90), clockwise: true)
                        }
                    }
                    .padding(5).opacity(0.4)
    
                    Text(card.content)
                        .font(Font.system(size: fontSize(for: geometry.size) * fontScaleFactor ))
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                        .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false ) : .default)
                }
                .cardify(isFaceUp: card.isFaceUp, gradient: gradient)
                .transition(AnyTransition.scale)
            }
        }.frame(minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading)
    }
    
    // MARK: - Drawing Constants
    
    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 3
    private let fontScaleFactor: CGFloat = 0.75
    private let aspectRatio: CGFloat = 0.7
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}

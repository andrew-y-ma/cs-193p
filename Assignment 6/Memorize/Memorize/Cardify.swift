import SwiftUI

struct Cardify: AnimatableModifier {
    var rotation: Double
    var color: Color
    
    init(isFaceUp: Bool, color: Color) {
        rotation = isFaceUp ? 0 : 180
        self.color = color
    }
    
    var isFaceUp: Bool {
        rotation < 90
    }
    
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth).fill(color)
                content
            }
                .opacity(isFaceUp ? 1: 0)
            RoundedRectangle(cornerRadius: cornerRadius).fill(color)
                .opacity(isFaceUp ? 0: 1)  
        }
            .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))

    }
    
    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 3

}

extension View {
    func cardify(isFaceUp: Bool, color: Color) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, color: color))
    }
}

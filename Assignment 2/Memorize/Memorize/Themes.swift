import SwiftUI

struct Theme {
    var name: String
    var emojis: [String]
    var color: Color
    var accentColor: Color
    var noOfPairs: Int?
}



let themes: [Theme] = [
    Theme(
        name: "Halloween",
        emojis: ["👻", "🎃", "🕷", "🕸", "🧙‍♂️"],
        color: .orange,
        accentColor: .red),
    Theme(name: "Winter", emojis: ["🌨","⛄️", "❄️", "⛷", "🏂", "🌨", "🎄", "🎅"], color: .blue, accentColor: .white),
    Theme(name: "Savannah", emojis: ["🦓", "🐆", "🦒", "🐘", "🦛", "🦏"], color: .green, accentColor: .yellow),
    Theme(name: "Farm", emojis: ["🐓", "🐄", "🐏", "🐖", "🚜", "🌾"], color: .green, accentColor: .yellow)
]




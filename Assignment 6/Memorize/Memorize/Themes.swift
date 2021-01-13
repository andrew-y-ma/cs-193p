import SwiftUI

struct Theme: Codable, Equatable, Hashable {
    var name: String
    var emojis: [String]
    var color: UIColor.RGB
    var noOfPairs: Int?
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    mutating func addEmojis(_ emojis: String) {
        for emoji in emojis {
            if !self.emojis.contains(String(emoji)) {
                self.emojis.append(String(emoji))
            }
        }
    }
    
    mutating func removeEmoji(_ emoji: String) {
        if let index = emojis.firstIndex(of: emoji) {
            emojis.remove(at: index)
        }
    }
}

let themes: [Theme] = [
    Theme(
        name: "Halloween",
        emojis: ["👻", "🎃", "🕷", "🕸", "🧙‍♂️"],
        color: UIColor.RGB(red: 255, green: 69, blue: 0, alpha: 1), noOfPairs: 5),
    Theme(name: "Winter", emojis: ["🌨","⛄️", "❄️", "⛷", "🏂", "🌨", "🎄", "🎅"], color: UIColor.RGB(red: 0, green: 0, blue: 128, alpha: 1), noOfPairs: 8),
    Theme(name: "Savannah", emojis: ["🦓", "🐆", "🦒", "🐘", "🦛", "🦏"], color: UIColor.RGB(red: 0, green: 128, blue: 0, alpha: 1), noOfPairs: 6),
    Theme(name: "Farm", emojis: ["🐓", "🐄", "🐏", "🐖", "🚜", "🌾"], color: UIColor.RGB(red: 0, green: 128, blue: 0, alpha: 1), noOfPairs: 6),
    Theme(name: "Ocean", emojis: ["🐳", "🐠", "🐙", "🦀", "🐡", "🐋", "🦈", "🦞"], color: UIColor.RGB(red: 0, green: 0, blue: 128, alpha: 1), noOfPairs: 8),
    Theme(name: "🤤", emojis: ["🍟", "🍕", "🍔", "🍡", "🥟", "🥐"], color: UIColor.RGB(red: 0, green: 0, blue: 100, alpha: 1), noOfPairs: 6)
]




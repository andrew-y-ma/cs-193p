import SwiftUI

struct IndividualEmoji: View {
    var selectedEmotes: Set<EmojiArt.Emoji>
    var emoji: EmojiArt.Emoji
    
    var body: some View {
        if selectedEmotes.contains(matching: emoji) {
            Text(emoji.text)
                .background(Color.blue)
            
        } else {
            Text(emoji.text)
        }
    }
}

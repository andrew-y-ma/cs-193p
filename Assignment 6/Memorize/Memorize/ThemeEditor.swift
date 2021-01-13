//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Andrew Ma on 2021-01-08.
//

import SwiftUI

struct ThemeEditor: View {
    @EnvironmentObject var store: EmojiMemoryGameStore
    @Binding var isShowing: Bool
    @State private var emojisToAdd: String = ""
    
    var theme: Theme = Theme(name: "", emojis: [], color: UIColor.RGB(red: 0, green: 50, blue: 0, alpha: 1), noOfPairs: 1)

//    init(isShowing: Bool) {
//        self.theme =
//    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Theme Editor").font(.headline).padding()
                HStack {
                    Spacer()
                    Button(action: {
                        isShowing = false
                    }, label: {
                        Text("Done")
                    }).padding()
                }
            }
            Divider()
            Form {
                Section {
                    Text(theme.name).padding()
                    TextField("Add Emoji", text: $emojisToAdd, onEditingChanged: { began in
                        if !began {
                            theme.addEmojis(emojisToAdd)
                            emojisToAdd = ""
                        }
                    }).padding()
                }
                Section(header: Text("Remove Emoji")) {
                    Grid(theme.emojis, id: \.self) { emoji in
                        Text(emoji).font(Font.system(size: self.fontSize))
                            .onTapGesture {
                                theme.removeEmoji(emoji)
                            }
                    }
                }
            }
        }
    }
    
    let fontSize: CGFloat = 40
}

//struct ThemeEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        ThemeEditor()
//    }
//}

import SwiftUI

struct EmojiMemoryGameChooser: View {
    @EnvironmentObject var store: EmojiMemoryGameStore
    @State private var editMode: EditMode = .inactive
    @State private var showEditor: Bool = false
    
    // for testing UI, remove later
//    let themes: [Theme] = [
//        Theme(
//            name: "Halloween",
//            emojis: ["👻", "🎃", "🕷", "🕸", "🧙‍♂️"],
//            color: UIColor.RGB(red: 255, green: 69, blue: 0, alpha: 1), noOfPairs: 5),
//        Theme(name: "Winter", emojis: ["🌨","⛄️", "❄️", "⛷", "🏂", "🌨", "🎄", "🎅"], color: UIColor.RGB(red: 0, green: 0, blue: 128, alpha: 1), noOfPairs: 8),
//        Theme(name: "Savannah", emojis: ["🦓", "🐆", "🦒", "🐘", "🦛", "🦏"], color: UIColor.RGB(red: 0, green: 128, blue: 0, alpha: 1), noOfPairs: 6),
//        Theme(name: "Farm", emojis: ["🐓", "🐄", "🐏", "🐖", "🚜", "🌾"], color: UIColor.RGB(red: 0, green: 128, blue: 0, alpha: 1), noOfPairs: 6),
//        Theme(name: "Ocean", emojis: ["🐳", "🐠", "🐙", "🦀", "🐡", "🐋", "🦈", "🦞"], color: UIColor.RGB(red: 0, green: 0, blue: 128, alpha: 1), noOfPairs: 8),
//        Theme(name: "🤤", emojis: ["🍟", "🍕", "🍔", "🍡", "🥟", "🥐"], color: UIColor.RGB(red: 0, green: 0, blue: 100, alpha: 1), noOfPairs: 6)
//    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes, id: \.self) { theme in
                    NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: theme)), label: {
                        Text(theme.name)
                    })
                }
            }
            .navigationBarTitle(store.name)
            .navigationBarItems(leading: Button(action: {
                    print("Pressed")
                }, label: {
                    Image(systemName: "plus").imageScale(.large)
                })
            .sheet(isPresented: $showEditor, content: {() -> Void
                ThemeEditor(isShowing: $showEditor)
            })
            ,
                trailing: EditButton()
            )
            .environment(\.editMode, $editMode)
        }
        
    }
}

struct EmojiMemoryGameChooser_Previews: PreviewProvider {
    static var previews: some View {
        let store = EmojiMemoryGameStore(named: "Hi There")
        return EmojiMemoryGameChooser().environmentObject(store)
    }
}

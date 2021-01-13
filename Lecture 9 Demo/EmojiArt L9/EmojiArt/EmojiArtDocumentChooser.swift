//
//  EmojiArtDocumentChooser.swift
//  EmojiArt
//
//  Created by Andrew Ma on 2021-01-07.
//  Copyright © 2021 CS193p Instructor. All rights reserved.
//

import SwiftUI

struct EmojiArtDocumentChooser: View {
    @EnvironmentObject var store: EmojiArtDocumentStore //common to use environment object for top levels view
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List { // Very similar to Table Views
                ForEach(store.documents) { document in
                    NavigationLink(destination: EmojiArtDocumentView(document: document)
                                    .navigationBarTitle(store.name(for: document))) {
                        EditableText(store.name(for: document), isEditing: editMode.isEditing) { name in
                            self.store.setName(name, for: document)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { self.store.documents[$0] }.forEach { document in
                        self.store.removeDocument(document)
                    }
                }
            }
            .navigationBarTitle(store.name)
            .navigationBarItems(leading: Button(action: {
                    store.addDocument()
                }, label: {
                    Image(systemName: "plus").imageScale(.large)
                }),
                trailing: EditButton()
            )
            .environment(\.editMode, $editMode) //this modifier has to be called after Edit Button is declared
        }
    }
}

struct EmojiArtDocumentChooser_Previews: PreviewProvider {
    static var previews: some View {
        let store = EmojiArtDocumentStore(named: "Preview Store")
        EmojiArtDocumentChooser().environmentObject(store)
    }
}

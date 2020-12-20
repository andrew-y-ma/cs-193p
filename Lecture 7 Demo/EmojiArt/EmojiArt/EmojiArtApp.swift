//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Andrew Ma on 2020-12-13.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: EmojiArtDocument())
        }
    }
}

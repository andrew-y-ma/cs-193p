//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/27/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    @State private var chosenPalette: String = ""
    
    init(document: EmojiArtDocument) {
        self.document = document
        _chosenPalette = State(wrappedValue: self.document.defaultPalette) //way to initialize state without onAppear
    }
    
    var body: some View {
        VStack {
            HStack {
                PaletteChooser(document: document, chosenPalette: $chosenPalette)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(chosenPalette.map { String($0) }, id: \.self) { emoji in
                            Text(emoji)
                                .font(Font.system(size: self.defaultEmojiSize))
                                .onDrag { NSItemProvider(object: emoji as NSString) }
                        }
                        
                    }
                }
                .onAppear { self.chosenPalette = self.document.defaultPalette }
                .padding(.horizontal)
                Button("Remove Selected Emojis", action: {
                    for emoji in selectedEmotes {
                        document.deleteEmoji(emoji)
                    }
                })
                .padding(.horizontal)
            }
            GeometryReader { geometry in
                ZStack {
                    Color.white.overlay(
                        OptionalImage(uiImage: self.document.backgroundImage)
                            .scaleEffect(selectedEmotes.isEmpty ? self.zoomScale : steadyStateZoomScale)
                            .offset(selectedEmotes.isEmpty ? self.panOffset : panOffset / gestureZoomScale)
                    )
                        .gesture(doubleTapToZoom(in: geometry.size))
                    
                    if self.isLoading {
                        Image(systemName: "hourglass").imageScale(.large).spinning()
                    }
                    else {
                        ForEach(self.document.emojis) { emoji in
                            Text(emoji.text)
                                .onTapGesture {
                                    selectedEmotes.toggleMatching(matching: emoji)
                                    print(selectedEmotes)
                                }
                                .background(selectedEmotes.contains(emoji) ?  Color.blue : Color.clear)
                                .font(animatableWithSize: selectedEmotes.contains(emoji) || selectedEmotes.isEmpty ? emoji.fontSize * self.zoomScale : emoji.fontSize * steadyStateZoomScale )
                                .position(self.position(for: emoji, in: geometry.size))
                                .gesture(panEmojiGesture())
                        }
                    }
                }
                .clipped()
                .gesture(self.panGesture())
                .gesture(self.zoomGesture())
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onReceive(self.document.$backgroundImage) { image in
                    self.zoomToFit(image, in: geometry.size)
                }
                .onDrop(of: ["public.image","public.text"], isTargeted: nil) { providers, location in
                    // SwiftUI bug (as of 13.4)? the location is supposed to be in our coordinate system
                    // however, the y coordinate appears to be in the global coordinate system
                    var location = CGPoint(x: location.x, y: geometry.convert(location, from: .global).y)
                    
                    // converts coordinates from iOS coordinate system to cartesian coordinate system
                    location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                    location = CGPoint(x: location.x - self.panOffset.width, y: location.y - self.panOffset.height)
                    
                    location = CGPoint(x: location.x / self.zoomScale, y: location.y / self.zoomScale)
                    return self.drop(providers: providers, at: location)
                }
                .navigationBarItems(trailing: Button(action: {
                    if let url = UIPasteboard.general.url, url != self.document.backgroundURL {
                        self.confirmBackgroundPaste = true
                    } else {
                        self.explainBackgroundPaste = true
                    }
                }, label: {
                    Image(systemName: "doc.on.clipboard").imageScale(.large)
                        .alert(isPresented: $explainBackgroundPaste, content: {
                            return Alert(title: Text("Paste Background"), message: Text("Copy the URL of an image to the clip board and touch this button to make it the background of your document."), dismissButton: .default(Text("OK")))
                        })
                }))
            }
            .zIndex(-1)
        }
        .alert(isPresented: $confirmBackgroundPaste, content: {
            return Alert(
                title: Text("Paste Background"),
                message: Text("Replace your background with \(UIPasteboard.general.url?.absoluteString ?? "nothing")?."),
                primaryButton: .default(Text("OK")) {
                    document.backgroundURL = UIPasteboard.general.url
                },
                secondaryButton: .cancel()
            )
        })
    }
    
    @State private var explainBackgroundPaste = false
    @State private var confirmBackgroundPaste = false
    
    var isLoading: Bool {
        document.backgroundURL != nil && document.backgroundImage == nil
    }
    
    @State private var steadyStateZoomScale: CGFloat = 1.0
    @GestureState private var gestureZoomScale: CGFloat = 1.0
    
    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, transaction in
                gestureZoomScale = latestGestureScale
            }
            .onEnded { finalGestureScale in
                if selectedEmotes.isEmpty {
                    self.steadyStateZoomScale *= finalGestureScale
                } else {
                    for emoji in selectedEmotes {
                        document.scaleEmoji(emoji, by: finalGestureScale)
                    }
                }
                selectedEmotes.removeAll()
            }
    }
    
    @State private var steadyStatePanOffset: CGSize = .zero
    @GestureState private var gesturePanOffset: CGSize = .zero
    @GestureState private var emojiGesturePanOffset: CGSize = .zero
    
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, transaction in
                gesturePanOffset = latestDragGestureValue.translation / self.zoomScale
        }
        .onEnded { finalDragGestureValue in
            self.steadyStatePanOffset = self.steadyStatePanOffset + (finalDragGestureValue.translation / self.zoomScale)
        }
    }
    
    private func panEmojiGesture() -> some Gesture {
        DragGesture()
            .updating($emojiGesturePanOffset) { latestDragGestureValue, emojiGesturePanOffset, transaction in
                emojiGesturePanOffset = latestDragGestureValue.translation / self.zoomScale
            }
            .onEnded{ finalDragGestureValue in
                for emoji in selectedEmotes {
                    document.moveEmoji(emoji, by: finalDragGestureValue.translation / self.zoomScale)
                }
                selectedEmotes.removeAll()
            }
    }
    
    @State private var selectedEmotes: Set = Set<EmojiArt.Emoji>()
    
    private func singleTapToClear(in size: CGSize) -> some Gesture {
        TapGesture(count: 1)
            .onEnded {
                selectedEmotes.removeAll()
            }
    }
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    self.zoomToFit(self.document.backgroundImage, in: size)
                }
            }
            .exclusively(before: singleTapToClear(in: size))
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0, size.height > 0, size.width > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            self.steadyStatePanOffset = .zero
            self.steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
        
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        
        //converts coordinates from cartesian coordinate system into ios coordinate system
        if selectedEmotes.isEmpty {
            location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        } else {
            location = CGPoint(x: location.x * steadyStateZoomScale , y: location.y * steadyStateZoomScale)
        }
        location = CGPoint(x: location.x + size.width/2, y: location.y + size.height/2)
        if selectedEmotes.contains(emoji) {
            location = CGPoint(x: location.x + panOffset.width / gestureZoomScale + (emojiGesturePanOffset.width * zoomScale), y: location.y + panOffset.height / gestureZoomScale + (emojiGesturePanOffset.height * zoomScale))
            print(emojiGesturePanOffset)
            print(panOffset)
        } else {
            location = CGPoint(x: location.x + panOffset.width / gestureZoomScale, y: location.y + panOffset.height / gestureZoomScale)
        }
        return location
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            self.document.backgroundURL = url
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                self.document.addEmoji(string, at: location, size: self.defaultEmojiSize)
            }
        }
        return found
    }
    
    private let defaultEmojiSize: CGFloat = 40
}

//
//  Wordbook.swift
//  OneWord
//
//  A selectable dictionary (word set). One today; more later — add an entry here
//  plus its bundled `<id>.json` and it shows up in the picker. Named `Wordbook`
//  to avoid clashing with Swift's `Dictionary`.
//

import SwiftUI

struct Wordbook: Identifiable, Hashable {
    let id: String       // also the bundled JSON resource name (`<id>.json`)
    let name: String     // shown on the book cover
    let cover: UInt      // book cover color (hex)
    let symbol: String   // SF Symbol stamped on the cover

    static let everydayEnglish = Wordbook(id: "words", name: "Dictionary of Everyday English", cover: 0x3B6FB0, symbol: "textformat.abc")
    static let emotions = Wordbook(id: "emotions", name: "Dictionary of Emotions", cover: 0xC0556B, symbol: "heart.fill")
    static let philosophy = Wordbook(id: "philosophy", name: "Dictionary of Philosophy", cover: 0x6C5CB8, symbol: "brain.head.profile")
    static let medical = Wordbook(id: "medical", name: "Dictionary of Medicine", cover: 0x2E9E8F, symbol: "cross.case.fill")
    static let character = Wordbook(id: "character", name: "Dictionary of Character", cover: 0xB0568A, symbol: "person.fill.questionmark")
    static let eloquence = Wordbook(id: "eloquence", name: "Dictionary of Eloquence", cover: 0xB5651D, symbol: "book.closed.fill")
    static let curiosities = Wordbook(id: "curiosities", name: "Dictionary of Curiosities", cover: 0x6B5B95, symbol: "sparkles")

    var coverColor: Color { Color(hex: cover) }

    /// Every dictionary the app offers. Grow this as new word sets are added.
    static let all: [Wordbook] = [everydayEnglish, emotions, philosophy, medical, character, eloquence, curiosities]

    /// Resolve a stored id back to a Wordbook (falls back to the default).
    static func named(_ id: String) -> Wordbook {
        all.first { $0.id == id } ?? everydayEnglish
    }
}

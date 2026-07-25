//
//  Wordbook.swift
//  MacBee
//
//  A selectable dictionary (word set). One today; more later — add an entry here
//  plus its bundled `<id>.json` and it shows up in the picker. Named `Wordbook`
//  to avoid clashing with Swift's `Dictionary`.
//

import Foundation

struct Wordbook: Identifiable, Hashable {
    let id: String     // also the bundled JSON resource name (`<id>.json`)
    let name: String   // shown in the picker

    static let everydayEnglish = Wordbook(id: "words", name: "Everyday English")
    static let emotions = Wordbook(id: "emotions", name: "Emotions")
    static let philosophy = Wordbook(id: "philosophy", name: "Philosophy")
    static let medical = Wordbook(id: "medical", name: "Medical")

    /// Every dictionary the app offers. Grow this as new word sets are added.
    static let all: [Wordbook] = [everydayEnglish, emotions, philosophy, medical]

    /// Resolve a stored id back to a Wordbook (falls back to the default).
    static func named(_ id: String) -> Wordbook {
        all.first { $0.id == id } ?? everydayEnglish
    }
}

//
//  Word.swift
//  OneWord — Shared model (member of app + widget targets)
//

import Foundation

/// One dictionary entry. Plain value type: no UI, no platform imports.
struct Word: Codable, Identifiable, Hashable {
    let term: String
    let partOfSpeech: String
    let hindi: String
    let definition: String
    let example: String

    /// Stable id — the term is unique in `words.json`.
    var id: String { term }
}

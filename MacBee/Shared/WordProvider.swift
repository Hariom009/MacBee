//
//  WordProvider.swift
//  MacBee — Shared model (member of app + widget targets)
//
//  The only thing that touches the bundle. Selection is date-derived and
//  deterministic, so the app and the widget compute the SAME word for a day
//  with no shared runtime state.
//

import Foundation

struct WordProvider {
    private let words: [Word]
    private let calendar: Calendar

    /// Injectable init for tests; the default loads the bundled list.
    init(words: [Word], calendar: Calendar = .current) {
        precondition(!words.isEmpty, "WordProvider needs at least one word")
        self.words = words
        self.calendar = calendar
    }

    /// The word for a given day, plus an optional manual `offset` (the widget's
    /// refresh button bumps this). Maps to a stable index so the same day+offset
    /// always yields the same word (and wraps once the list ends).
    func word(for date: Date, offset: Int = 0) -> Word {
        // Days since a fixed reference day → index. Non-negative via modulo fix-up.
        let day = calendar.startOfDay(for: date)
        let ref = calendar.startOfDay(for: Date(timeIntervalSinceReferenceDate: 0))
        let days = calendar.dateComponents([.day], from: ref, to: day).day ?? 0
        let index = (((days + offset) % words.count) + words.count) % words.count
        return words[index]
    }

    /// The whole collection, for the browse/search list.
    var allWords: [Word] { words }
}

extension WordProvider {
    /// Loads `words.json` from the given bundle. Traps on a missing/broken file —
    /// the word list ships with the app, so a failure here is a build error, not
    /// a runtime condition to recover from.
    init(bundle: Bundle = .main, resource: String = "words", calendar: Calendar = .current) {
        guard let url = bundle.url(forResource: resource, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            fatalError("\(resource).json is missing from the bundle — check target membership")
        }
        do {
            let words = try JSONDecoder().decode([Word].self, from: data)
            self.init(words: words, calendar: calendar)
        } catch {
            fatalError("words.json failed to decode: \(error)")
        }
    }
}

//
//  WordViewModel.swift
//  MacBee
//
//  The app's testable seam: holds the day's word for the SELECTED dictionary,
//  sourced from the Shared WordProvider. No SwiftUI imports, no view types.
//  MainActor-isolated by the project's default actor isolation.
//

import Foundation
import Observation

@Observable
final class WordViewModel {
    private(set) var word: Word
    private(set) var wordbook: Wordbook
    private var provider: WordProvider
    private var offset = 0   // manual "New Word" taps, applied on top of the day's word

    init(wordbook: Wordbook = .everydayEnglish) {
        let provider = WordProvider(resource: wordbook.id)
        self.wordbook = wordbook
        self.provider = provider
        self.word = provider.word(for: Date())
    }

    /// Switch dictionaries and show that dictionary's own word of the day.
    func select(_ wordbook: Wordbook, for date: Date = Date()) {
        guard wordbook != self.wordbook else { return }
        self.wordbook = wordbook
        self.provider = WordProvider(resource: wordbook.id)
        offset = 0
        word = provider.word(for: date)
    }

    /// Re-pick for the given day. Called when the app becomes active so a window
    /// left open across midnight rolls to the new word.
    func refresh(for date: Date = Date()) {
        word = provider.word(for: date, offset: offset)
    }

    /// Advance to the next word — sequential within the current dictionary, not random.
    func shuffle(for date: Date = Date()) {
        offset += 1
        word = provider.word(for: date, offset: offset)
    }
}

//
//  WordViewModel.swift
//  MacBee
//
//  The app's testable seam: holds the day's word, sourced from the Shared
//  WordProvider. No SwiftUI imports, no view types. MainActor-isolated by the
//  project's default actor isolation.
//

import Foundation
import Observation

@Observable
final class WordViewModel {
    private(set) var word: Word
    private let provider: WordProvider

    init(provider: WordProvider = WordProvider()) {
        self.provider = provider
        self.word = provider.word(for: Date())
    }

    /// Re-pick for the given day. Called when the app becomes active so a window
    /// left open across midnight rolls to the new word.
    func refresh(for date: Date = Date()) {
        word = provider.word(for: date)
    }
}

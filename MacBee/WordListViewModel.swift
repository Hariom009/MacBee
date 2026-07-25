//
//  WordListViewModel.swift
//  MacBee
//
//  Browse/search over a chosen dictionary. Sorts once (alphabetical), filters by
//  term. Testable seam: pure over WordProvider, no view types.
//

import Foundation
import Observation

@Observable
final class WordListViewModel {
    private(set) var wordbook: Wordbook
    private(set) var allWords: [Word]

    init(wordbook: Wordbook = .everydayEnglish) {
        self.wordbook = wordbook
        self.allWords = Self.load(wordbook)
    }

    /// Switch dictionaries and reload its words.
    func select(_ wordbook: Wordbook) {
        guard wordbook != self.wordbook else { return }
        self.wordbook = wordbook
        self.allWords = Self.load(wordbook)
    }

    var count: Int { allWords.count }

    /// Words whose term contains `query` (case/diacritic-insensitive). Empty query → all.
    func results(for query: String) -> [Word] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return allWords }
        return allWords.filter { $0.term.localizedCaseInsensitiveContains(q) }
    }

    private static func load(_ wordbook: Wordbook) -> [Word] {
        WordProvider(resource: wordbook.id).allWords.sorted {
            $0.term.localizedCaseInsensitiveCompare($1.term) == .orderedAscending
        }
    }
}

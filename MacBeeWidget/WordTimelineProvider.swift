//
//  WordTimelineProvider.swift
//  MacBeeWidget
//
//  The widget's "view model": WidgetKit asks it what to show and when to refresh.
//  Same Shared model as the app (WordProvider), so both agree on the day's word.
//

import WidgetKit
import Foundation

struct WordTimelineProvider: TimelineProvider {
    // Loads words.json from the WIDGET bundle — words.json must be a member of the
    // widget target too (see setup steps), or this traps on launch.
    private let words = WordProvider()
    private let calendar = Calendar.current

    func placeholder(in context: Context) -> WordEntry {
        WordEntry(date: Date(), word: words.word(for: Date()))
    }

    func getSnapshot(in context: Context, completion: @escaping (WordEntry) -> Void) {
        completion(WordEntry(date: Date(), word: words.word(for: Date())))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WordEntry>) -> Void) {
        let today = calendar.startOfDay(for: Date())
        let shift = WordStore.offset   // manual "refresh" taps, applied on top of the day's word
        // One entry per day for the next week; WidgetKit rotates through them and
        // rebuilds the timeline after the last (.atEnd) — no background wakeups needed.
        let entries = (0..<7).compactMap { dayOffset -> WordEntry? in
            guard let day = calendar.date(byAdding: .day, value: dayOffset, to: today) else { return nil }
            return WordEntry(date: day, word: words.word(for: day, offset: shift))
        }
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

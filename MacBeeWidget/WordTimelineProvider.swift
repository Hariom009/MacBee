//
//  WordTimelineProvider.swift
//  MacBeeWidget
//
//  The widget's "view model": WidgetKit asks it what to show and when to refresh.
//  The dictionary comes from the App Group (chosen in the app's Settings); the
//  manual refresh offset from WordStore. Same Shared model as the app.
//

import WidgetKit
import Foundation

struct WordTimelineProvider: TimelineProvider {
    private let calendar = Calendar.current

    // Loads the chosen dictionary's JSON from the WIDGET bundle — every dictionary
    // json must be a member of the widget target too, or this traps on launch.
    private func provider() -> WordProvider {
        WordProvider(resource: AppGroup.widgetDictionaryID)
    }

    func placeholder(in context: Context) -> WordEntry {
        WordEntry(date: Date(), word: provider().word(for: Date(), offset: WordStore.offset))
    }

    func getSnapshot(in context: Context, completion: @escaping (WordEntry) -> Void) {
        completion(WordEntry(date: Date(), word: provider().word(for: Date(), offset: WordStore.offset)))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WordEntry>) -> Void) {
        let words = provider()
        let today = calendar.startOfDay(for: Date())
        let shift = WordStore.offset
        let entries = (0..<7).compactMap { dayOffset -> WordEntry? in
            guard let day = calendar.date(byAdding: .day, value: dayOffset, to: today) else { return nil }
            return WordEntry(date: day, word: words.word(for: day, offset: shift))
        }
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

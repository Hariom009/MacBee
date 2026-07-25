//
//  WordWidgetView.swift
//  MacBeeWidget
//
//  Renders one WordEntry. Dumb view — no data loading.
//

import SwiftUI
import WidgetKit
import AppIntents

struct WordWidgetView: View {
    let entry: WordEntry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(entry.word.term)
                    .font(.headline)
                Spacer(minLength: 4)
                Button(intent: RefreshWordIntent()) {
                    Image(systemName: "arrow.clockwise")
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
            }
            Text(entry.word.partOfSpeech)
                .font(.caption).italic()
                .foregroundStyle(.secondary)
            Text(entry.word.definition)
                .font(.callout)
                .lineLimit(family == .systemSmall ? 3 : 4)
            if !entry.word.hindi.isEmpty {
                Text(entry.word.hindi)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(family == .systemSmall ? 2 : 3)
            }
            if family != .systemSmall, !entry.word.example.isEmpty {
                Text("\u{201C}\(entry.word.example)\u{201D}")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

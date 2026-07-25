//
//  WordWidgetView.swift
//  MacBeeWidget
//
//  Compact word-of-the-day card: serif headword + part of speech, the Devanagari
//  meaning with an accent rule, and the definition. Refresh button top-right.
//  No example sentence — it costs too much space in a widget.
//

import SwiftUI
import WidgetKit
import AppIntents

struct WordWidgetView: View {
    let entry: WordEntry
    @Environment(\.widgetFamily) private var family
    @Environment(\.colorScheme) private var scheme

    private var small: Bool { family == .systemSmall }
    private var large: Bool { family == .systemLarge }

    var body: some View {
        let t = Theme.of(scheme)
        let w = entry.word
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 7) {
                VStack(alignment: .leading, spacing: 1) {
                    Text(w.term)
                        .font(.serif(small ? 24 : (large ? 36 : 28)))
                        .foregroundStyle(.red)
                        .lineLimit(1).minimumScaleFactor(0.4)
                    Text(w.partOfSpeech)
                        .font(.serif(small ? 10.5 : 12).italic())
                        .foregroundStyle(t.muted)
                }
                Spacer(minLength: 4)
                Button(intent: RefreshWordIntent()) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(t.accent)
                        .padding(5)
                        .background(t.accent.opacity(0.15), in: Circle())
                }
                .buttonStyle(.plain)
            }

            if !w.hindi.isEmpty {
                Text(w.hindi)
                    .font(.system(size: small ? 13 : (large ? 12.5 : 11.5)))
                    .foregroundStyle(t.ink)
                    .lineLimit(small ? 6 : 2)
                    .padding(.leading, small ? 0 : 9)
                    .overlay(alignment: .leading) {
                        if !small { Rectangle().fill(t.rule).frame(width: 2) }
                    }
                    .padding(.top, small ? 6 : 8)
            }

            // Small has no room for both languages — Hindi only (full). Definition on medium/large.
            if !small {
                Text(w.definition)
                    .font(.system(size: large ? 12.5 : 11.5))
                    .foregroundStyle(t.definition)
                    .lineLimit(large ? 10 : 3)
                    .padding(.top, 7)
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(t.background, for: .widget)
    }
}

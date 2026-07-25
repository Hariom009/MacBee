//
//  WordWidget.swift
//  MacBeeWidget
//
//  The widget definition + the extension's @main entry point.
//

import WidgetKit
import SwiftUI

struct WordWidget: Widget {
    let kind = "WordWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WordTimelineProvider()) { entry in
            WordWidgetView(entry: entry)
        }
        .configurationDisplayName("Word of the Day")
        .description("A new word every day.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// NOTE: the widget wizard generates its own `@main ...WidgetBundle` — delete that
// generated file so there is exactly ONE @main in the widget target.
@main
struct MacBeeWidgetBundle: WidgetBundle {
    var body: some Widget {
        WordWidget()
    }
}

#Preview(as: .systemMedium) {
    WordWidget()
} timeline: {
    WordEntry(
        date: .now,
        word: Word(
            term: "petrichor",
            partOfSpeech: "noun",
            hindi: "बारिश के बाद सूखी ज़मीन पर पड़ने वाली सुखद मिट्टी जैसी महक",
            definition: "The pleasant, earthy smell after rain falls on dry ground.",
            example: "The first storm of autumn filled the air with petrichor."
        )
    )
}

//
//  WordEntry.swift
//  OneWordWidget
//
//  One rendered moment of the widget: a date + the word to show on that day.
//

import WidgetKit

struct WordEntry: TimelineEntry {
    let date: Date
    let word: Word
}

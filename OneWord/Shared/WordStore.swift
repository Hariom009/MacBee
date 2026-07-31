//
//  WordStore.swift
//  OneWord — Shared (app + widget)
//
//  The manual "New Word / refresh" offset, added on top of the day's word. Lives
//  in the App Group so the app and the widget always show the SAME word — either
//  one's refresh advances it, and switching dictionaries resets it.
//  nonisolated because the widget's timeline provider reads it off the main actor.
//

import Foundation

enum WordStore {
    // ponytail: bumped from "refreshOffset" to abandon stale test values (starts at 0 = today's word).
    nonisolated private static let key = "wordOffset"

    nonisolated static var offset: Int {
        get { AppGroup.defaults.integer(forKey: key) }
        set { AppGroup.defaults.set(newValue, forKey: key) }
    }

    nonisolated static func advance() { offset += 1 }
    nonisolated static func reset() { offset = 0 }
}

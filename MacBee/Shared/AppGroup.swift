//
//  AppGroup.swift
//  MacBee — Shared (app + widget)
//
//  Storage shared between the app and the widget extension (an App Group), so the
//  app's Settings can choose which dictionary the widget shows its word of the day from.
//

import Foundation

enum AppGroup {
    static let id = "group.com.hariom.swift.MacBee"

    /// Falls back to standard defaults if the App Group isn't provisioned yet
    /// (then the app + widget won't share — see the setup note).
    static var defaults: UserDefaults { UserDefaults(suiteName: id) ?? .standard }

    static let widgetDictionaryKey = "widgetDictionaryID"

    /// Dictionary id the widget renders (defaults to Everyday English's `words`).
    static var widgetDictionaryID: String {
        defaults.string(forKey: widgetDictionaryKey) ?? "words"
    }
}

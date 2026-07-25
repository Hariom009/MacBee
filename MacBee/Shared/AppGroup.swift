//
//  AppGroup.swift
//  MacBee — Shared (app + widget)
//
//  Storage shared between the app and the widget extension (an App Group). The
//  selected dictionary lives here so ONE setting drives both the app and the widget.
//

import Foundation

enum AppGroup {
    static let id = "group.com.hariom.swift.MacBee"

    /// Falls back to standard defaults if the App Group isn't provisioned yet
    /// (then the app + widget won't share — build once in Xcode to provision it).
    static var defaults: UserDefaults { UserDefaults(suiteName: id) ?? .standard }

    static let dictionaryKey = "dictionaryID"

    /// The selected dictionary id (defaults to Everyday English's `words`).
    static var dictionaryID: String {
        defaults.string(forKey: dictionaryKey) ?? "words"
    }
}

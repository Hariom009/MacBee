//
//  WordStore.swift
//  MacBee — Shared (member of app + widget targets)
//
//  The one bit of shared runtime state: a manual "refresh" offset the widget's
//  button bumps, added on top of the date-derived index so each tap shows a new
//  word. Stored in the widget extension's own defaults — the refresh intent and
//  the timeline provider both run in the widget extension, so they share it with
//  no App Group (and no provisioning). `nonisolated` because the timeline
//  provider reads it off the main actor.
//  ponytail: extension-local defaults; add an App Group only if the main app ever
//  needs to read/reset this offset too.
//

import Foundation

enum WordStore {
    nonisolated private static let key = "refreshOffset"

    nonisolated static var offset: Int {
        get { UserDefaults.standard.integer(forKey: key) }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }

    nonisolated static func advance() { offset += 1 }
}

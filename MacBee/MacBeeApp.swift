//
//  MacBeeApp.swift
//  MacBee
//
//  Created by Hari's Mac on 23.07.2026.
//

import SwiftUI

@main
struct MacBeeApp: App {
    @AppStorage("appearance") private var appearance = Appearance.system.rawValue

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WordView()
            }
            .preferredColorScheme((Appearance(rawValue: appearance) ?? .system).colorScheme)
        }
    }
}

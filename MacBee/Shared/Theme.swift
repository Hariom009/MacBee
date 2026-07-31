//
//  Theme.swift
//  MacBee — Shared (app + widget)
//
//  The "cream paper / ink serif / honey accent" design system (from the Claude
//  Design board). Honey accent in light, ember in dark. Resolve with
//  Theme.of(colorScheme).
//  ponytail: uses the system serif (New York) for headwords; bundle Newsreader +
//  Tiro Devanagari fonts later for pixel-exact type.
//

import SwiftUI

struct Theme {
    let background: Color   // paper / night
    let surface: Color      // fields, pickers
    let ink: Color          // primary text / headword
    let muted: Color        // part of speech, labels
    let definition: Color
    let example: Color
    let accent: Color       // honey / ember
    let rule: Color         // the Hindi left border
    let hairline: Color     // dividers

    static let light = Theme(
        background: Color(hex: 0xF7F2E7),
        surface:    Color(hex: 0xFFFDF7),
        ink:        Color(hex: 0x221E19),
        muted:      Color(hex: 0x8B7F6E),
        definition: Color(hex: 0x3A342C),
        example:    Color(hex: 0x5C5347),
        accent:     Color(hex: 0xB4771A),
        rule:       Color(hex: 0xE0C48F),
        hairline:   Color(hex: 0x221E19).opacity(0.11)
    )

    static let dark = Theme(
        background: Color(hex: 0x000000),
        surface:    Color(hex: 0x1A1A1A),
        ink:        Color(hex: 0xF5EEDF),
        muted:      Color(hex: 0x9C9284),
        definition: Color(hex: 0xD6CCBA),
        example:    Color(hex: 0xBFB5A3),
        accent:     Color(hex: 0xE4685C),
        rule:       Color(hex: 0xE4685C).opacity(0.55),
        hairline:   Color.white.opacity(0.11)
    )

    static func of(_ scheme: ColorScheme) -> Theme { scheme == .dark ? .dark : .light }
}

extension Color {
    init(hex: UInt) {
        self.init(.sRGB,
                  red:   Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue:  Double(hex & 0xFF) / 255)
    }
}

extension Font {
    /// Editorial serif headword face (New York stands in for Newsreader).
    static func serif(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }
}

//
//  WordWidgetView.swift
//  OneWordWidget
//
//  Word-of-the-day card, redesigned from the "Word of the Day Widget" Claude
//  Design spec: warm paper (light) / soft-dark card, honey/ember accent, uppercase
//  part of speech, an accent rule beside the Devanagari meaning, and — on Large —
//  an italic example under a hairline. Content grows with the family:
//    small  — headword · pos · hindi
//    medium — + accent rule + definition (3 lines)
//    large  — + bigger type + example under a hairline
//  Both appearances follow the system color scheme.
//
//  ponytail: headword/example use the system serif (New York) and pos/definition
//  the system sans — stand-ins for Newsreader / Instrument Sans. Hindi uses the
//  platform Devanagari face for Tiro Devanagari Hindi. Bundle those three .ttf +
//  register UIAppFonts (widget target) to reach the pixel-exact spec.
//

import SwiftUI
import WidgetKit
import AppIntents

// MARK: - Palette (from the design spec; local to the widget so the app's Theme is untouched)

private struct WPalette {
    let card: Color        // container background
    let accent: Color      // headword + accent rule
    let ink: Color         // hindi
    let pos: Color         // part of speech
    let body: Color        // definition
    let example: Color
    let refresh: Color      // refresh glyph tint
    let rule: Color         // accent rule fill (accent, dimmed)
    let hairline: Color     // large divider above the example

    static let light = WPalette(
        card:    Color(hex: 0xF7F2E7),
        accent:  Color(hex: 0xB4771A),
        ink:     Color(hex: 0x221E19),
        pos:     Color(hex: 0x9A9184),
        body:    Color(hex: 0x5F594E),
        example: Color(hex: 0x8A8375),
        refresh: Color(hex: 0xB8AF9E),
        rule:    Color(hex: 0xB4771A).opacity(0.50),
        hairline: Color(hex: 0x221E19).opacity(0.09)
    )
    static let dark = WPalette(
        card:    Color(hex: 0x1A1815),
        accent:  Color(hex: 0xE4685C),
        ink:     Color(hex: 0xF0E9DC),
        pos:     Color(hex: 0x7C7466),
        body:    Color(hex: 0xA8A093),
        example: Color(hex: 0x7C7466),
        refresh: Color(hex: 0x5C564B),
        rule:    Color(hex: 0xE4685C).opacity(0.55),
        hairline: Color(hex: 0xF0E9DC).opacity(0.11)
    )
    static func of(_ s: ColorScheme) -> WPalette { s == .dark ? .dark : .light }
}

// MARK: - Paper unwrap

/// The card content folded shut along its top edge, like a note not yet opened.
private struct PaperFold: ViewModifier {
    let folded: Bool
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(.degrees(folded ? -74 : 0), axis: (x: 1, y: 0, z: 0),
                              anchor: .top, perspective: 0.55)
            .scaleEffect(y: folded ? 0.88 : 1, anchor: .top)
            .opacity(folded ? 0 : 1)
    }
}

private extension AnyTransition {
    /// New word unfolds from the top edge while the old one fades — paper being opened.
    /// Runs whenever the entry's word changes: daily rollover or the refresh button.
    ///
    /// ponytail: one fold on the whole content block. Widgets get no per-frame
    /// animation (`TimelineView(.animation)` is unavailable), so crumple/fibre
    /// effects are out; stagger the lines with delayed transitions only if the
    /// single fold reads too flat.
    static var paperUnwrap: AnyTransition {
        .asymmetric(
            insertion: .modifier(active: PaperFold(folded: true), identity: PaperFold(folded: false)),
            removal: .opacity
        )
    }
}

// MARK: - View

struct WordWidgetView: View {
    let entry: WordEntry
    @Environment(\.widgetFamily) private var family
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let p = WPalette.of(scheme)
        let w = entry.word
        Group {
            switch family {
            case .systemSmall: small(w, p)
            case .systemLarge: large(w, p)
            default:           medium(w, p)   // .systemMedium
            }
        }
        .id(w.term)                      // new word = new identity, so the transition fires
        .transition(.paperUnwrap)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(p.card, for: .widget)
    }

    // MARK: Shared header — headword + part of speech, refresh top-right

    @ViewBuilder
    private func header(_ w: Word, _ p: WPalette,
                        headword: CGFloat, hwWeight: Font.Weight, hwTracking: CGFloat,
                        posGap: CGFloat, pos: CGFloat, posTracking: CGFloat,
                        glyph: CGFloat, hit: CGFloat) -> some View {
        // Refresh is a top-trailing overlay (not an HStack sibling) so the headword
        // scales against a *definite* width. Next to a greedy Spacer it would instead
        // be handed its full ideal width and truncate rather than shrink.
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: posGap) {
                Text(w.term)
                    .font(.serif(headword, hwWeight))
                    .tracking(hwTracking)
                    .foregroundStyle(p.accent)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)   // long headwords (e.g. "hypercalcaemia") shrink to fit, never truncate
                Text(w.partOfSpeech.uppercased())
                    .font(.system(size: pos, weight: .medium))
                    .tracking(posTracking)
                    .foregroundStyle(p.pos)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.trailing, hit + 6)   // reserve room for the refresh glyph

            Button(intent: RefreshWordIntent()) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: glyph, weight: .regular))
                    .foregroundStyle(p.refresh)
                    .frame(width: hit, height: hit)
                    .contentShape(Rectangle())   // ponytail: tap area = glyph frame; 44pt would overlap headword
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: Accent rule + Hindi (medium & large)

    @ViewBuilder
    private func ruledHindi(_ w: Word, _ p: WPalette, size: CGFloat, gap: CGFloat, lines: Int) -> some View {
        HStack(alignment: .top, spacing: gap) {
            RoundedRectangle(cornerRadius: 1).fill(p.rule).frame(width: 2)
            Text(w.hindi)
                .font(.system(size: size))
                .lineSpacing(2)
                .foregroundStyle(p.ink)
                .lineLimit(lines)
                .minimumScaleFactor(0.55)   // Hindi is sentence-length; shrink to fill its lines rather than truncate
        }
        .fixedSize(horizontal: false, vertical: true)   // rule matches the Hindi's height
    }

    // MARK: Small — headword · pos · hindi (no definition/rule/example)

    private func small(_ w: Word, _ p: WPalette) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            header(w, p, headword: 23, hwWeight: .medium, hwTracking: -0.2,
                   posGap: 5, pos: 9.5, posTracking: 1.1, glyph: 14, hit: 20)
            Spacer(minLength: 8)
            Text(w.hindi)
                .font(.system(size: 15))
                .lineSpacing(2)
                .foregroundStyle(p.ink)
                .lineLimit(5)
                .minimumScaleFactor(0.55)
        }
        .padding(16)
    }

    // MARK: Medium — + accent rule + definition

    private func medium(_ w: Word, _ p: WPalette) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            header(w, p, headword: 26, hwWeight: .medium, hwTracking: -0.3,
                   posGap: 6, pos: 10, posTracking: 1.2, glyph: 15, hit: 22)
            Spacer(minLength: 6)
            VStack(alignment: .leading, spacing: 8) {
                ruledHindi(w, p, size: 15, gap: 12, lines: 2)
                if !w.definition.isEmpty {
                    Text(w.definition)
                        .font(.system(size: 12))
                        .lineSpacing(2)
                        .foregroundStyle(p.body)
                        .lineLimit(3)
                        .minimumScaleFactor(0.7)
                }
            }
        }
        .padding(17)
    }

    // MARK: Large — + bigger type + example under a hairline

    private func large(_ w: Word, _ p: WPalette) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 18) {
                header(w, p, headword: 40, hwWeight: .regular, hwTracking: -0.6,
                       posGap: 9, pos: 10.5, posTracking: 1.4, glyph: 17, hit: 26)
                ruledHindi(w, p, size: 20, gap: 16, lines: 4)
                if !w.definition.isEmpty {
                    Text(w.definition)
                        .font(.system(size: 14))
                        .lineSpacing(3)
                        .foregroundStyle(p.body)
                        .lineLimit(5)
                        .minimumScaleFactor(0.7)
                }
            }
            Spacer(minLength: 12)
            if !w.example.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Rectangle().fill(p.hairline).frame(height: 1)
                    Text("“\(w.example)”")
                        .font(.serif(14).italic())
                        .lineSpacing(2)
                        .foregroundStyle(p.example)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }
            }
        }
        .padding(26)
    }
}

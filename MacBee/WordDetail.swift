//
//  WordDetail.swift
//  MacBee
//
//  Renders one Word (term, part of speech, definition, Hindi, example).
//  Shared by WordView (today) and the browse list's detail — dumb, no data loading.
//

import SwiftUI

struct WordDetail: View {
    let word: Word

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(word.term)
                    .font(.largeTitle.bold())
                Text(word.partOfSpeech)
                    .font(.title3).italic()
                    .foregroundStyle(.secondary)
                Text(word.definition)
                    .font(.title3)
                if !word.hindi.isEmpty {
                    Text(word.hindi)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                if !word.example.isEmpty {
                    Text("\u{201C}\(word.example)\u{201D}")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(24)
        }
    }
}

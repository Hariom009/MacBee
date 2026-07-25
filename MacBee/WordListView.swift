//
//  WordListView.swift
//  MacBee
//
//  Browse every word in the selected dictionary alphabetically. A top bar holds
//  the search field with the dictionary picker beside it; selecting a word pushes
//  its detail.
//

import SwiftUI

struct WordListView: View {
    @AppStorage("dictionaryID") private var dictionaryID = Wordbook.everydayEnglish.id
    @State private var model = WordListViewModel()
    @State private var query = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                searchField
                dictionaryPicker
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)

            Divider()

            List(model.results(for: query)) { word in
                NavigationLink {
                    WordDetail(word: word)
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(word.term)
                            .font(.headline)
                        Text(word.partOfSpeech)
                            .font(.caption).italic()
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("All Words")
        .onAppear { model.select(Wordbook.named(dictionaryID)) }
        .onChange(of: dictionaryID) { _, id in model.select(Wordbook.named(id)) }
    }

    private var searchField: some View {
        HStack(spacing: 6) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Search \(model.count) words", text: $query)
                .textFieldStyle(.plain)
            if !query.isEmpty {
                Button { query = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
    }

    private var dictionaryPicker: some View {
        Menu {
            Picker("Dictionary", selection: $dictionaryID) {
                ForEach(Wordbook.all) { book in
                    Text(book.name).tag(book.id)
                }
            }
        } label: {
            Label(Wordbook.named(dictionaryID).name, systemImage: "books.vertical")
        }
        .fixedSize()
        .help("Select dictionary")
    }
}

#Preview {
    NavigationStack { WordListView() }
}

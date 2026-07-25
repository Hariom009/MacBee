//
//  WordView.swift
//  MacBee
//
//  Today's word. Dumb view — binds to WordViewModel, does no data loading.
//

import SwiftUI

struct WordView: View {
    @State private var model = WordViewModel()
    @AppStorage("dictionaryID") private var dictionaryID = Wordbook.everydayEnglish.id
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        WordDetail(word: model.word)
            .navigationTitle("Word of the Day")
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    NavigationLink {
                        WordListView()
                    } label: {
                        Label("Search Words", systemImage: "magnifyingglass")
                    }
                    Menu {
                        Picker("Dictionary", selection: $dictionaryID) {
                            ForEach(Wordbook.all) { book in
                                Text(book.name).tag(book.id)
                            }
                        }
                    } label: {
                        Label(Wordbook.named(dictionaryID).name, systemImage: "books.vertical")
                    }
                    .help("Select dictionary")
                }
            }
            .onChange(of: scenePhase) { _, phase in
                if phase == .active { model.refresh() }
            }
    }
}

#Preview {
    WordView()
}

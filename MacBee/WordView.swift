//
//  WordView.swift
//  MacBee
//
//  Today's word. Dumb view — binds to WordViewModel, does no data loading.
//

import SwiftUI

struct WordView: View {
    @State private var model = WordViewModel()
    @State private var showingSettings = false
    @AppStorage("dictionaryID") private var dictionaryID = Wordbook.everydayEnglish.id
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        WordDetail(word: model.word, showDate: true, dictionaryName: model.wordbook.name)
            .navigationTitle("Word of the Day")
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        model.shuffle()
                    } label: {
                        Label("New Word", systemImage: "arrow.clockwise")
                    }
                    .help("Show another word")
                    NavigationLink {
                        WordListView()
                    } label: {
                        Label("Search Words", systemImage: "magnifyingglass")
                    }
                    Button {
                        showingSettings = true
                    } label: {
                        Label("Settings", systemImage: "gearshape")
                    }
                    .help("Settings")
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .onAppear { model.select(Wordbook.named(dictionaryID)) }
            .onChange(of: dictionaryID) { _, id in model.select(Wordbook.named(id)) }
            .onChange(of: scenePhase) { _, phase in
                if phase == .active { model.refresh() }
            }
    }
}

#Preview {
    WordView()
}

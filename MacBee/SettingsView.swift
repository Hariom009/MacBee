//
//  SettingsView.swift
//  MacBee
//
//  Presented as a sheet from the gear button. Appearance + the dictionary. The
//  dictionary lives in the App Group, so it drives both the app and the widget.
//

import SwiftUI
import WidgetKit

struct SettingsView: View {
    @AppStorage("appearance") private var appearance = Appearance.system.rawValue
    @AppStorage("dictionaryID", store: AppGroup.defaults)
    private var dictionaryID = Wordbook.everydayEnglish.id
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Settings").font(.headline)
                Spacer()
                Button("Done") { dismiss() }
                    .keyboardShortcut(.defaultAction)
            }
            .padding()

            Divider()

            Form {
                Picker("Appearance", selection: $appearance) {
                    ForEach(Appearance.allCases) { mode in
                        Text(mode.name).tag(mode.rawValue)
                    }
                }
                .pickerStyle(.segmented)

                Picker("Dictionary", selection: $dictionaryID) {
                    ForEach(Wordbook.all) { book in
                        Text(book.name).tag(book.id)
                    }
                }
                .onChange(of: dictionaryID) { _, _ in
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
            .formStyle(.grouped)
        }
        .frame(width: 380, height: 240)
    }
}

#Preview {
    SettingsView()
}

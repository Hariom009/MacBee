//
//  SettingsView.swift
//  MacBee
//
//  Presented as a sheet from the gear button. Appearance, the app's dictionary,
//  and the widget's dictionary (shared with the extension via the App Group).
//

import SwiftUI
import WidgetKit

struct SettingsView: View {
    @AppStorage("appearance") private var appearance = Appearance.system.rawValue
    @AppStorage("dictionaryID") private var dictionaryID = Wordbook.everydayEnglish.id
    @AppStorage("widgetDictionaryID", store: AppGroup.defaults)
    private var widgetDictionaryID = Wordbook.everydayEnglish.id
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

                Picker("Widget dictionary", selection: $widgetDictionaryID) {
                    ForEach(Wordbook.all) { book in
                        Text(book.name).tag(book.id)
                    }
                }
                .onChange(of: widgetDictionaryID) { _, _ in
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
            .formStyle(.grouped)
        }
        .frame(width: 400, height: 280)
    }
}

#Preview {
    SettingsView()
}

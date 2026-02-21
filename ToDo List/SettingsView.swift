//
//  SettingsView.swift
//  ToDo List
//
//  Created by Mzzf on 2026/2/21.
//

import SwiftUI

struct SettingsView: View {
    @Bindable private var settings = AppSettings.shared

    var body: some View {
        Form {
            Picker(L("settings.language"), selection: $settings.language) {
                ForEach(AppLanguage.allCases) { lang in
                    Text(lang.displayName).tag(lang)
                }
            }
        }
        .formStyle(.grouped)
        .frame(width: 420, height: 120)
    }
}

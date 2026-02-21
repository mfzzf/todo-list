//
//  SettingsView.swift
//  ToDo List
//
//  Created by Mzzf on 2026/2/21.
//

import SwiftUI

struct SettingsView: View {
    @Bindable private var settings = AppSettings.shared
    @State private var updateState: UpdateCheckState = .idle

    private var currentVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }

    var body: some View {
        Form {
            Picker(L("settings.language"), selection: $settings.language) {
                ForEach(AppLanguage.allCases) { lang in
                    Text(lang.displayName).tag(lang)
                }
            }

            Section(L("about.title")) {
                LabeledContent(L("about.version")) {
                    Text("v\(currentVersion)")
                        .foregroundStyle(.secondary)
                }

                HStack {
                    switch updateState {
                    case .idle:
                        Button(L("about.checkUpdate")) {
                            Task { await checkForUpdate() }
                        }
                    case .checking:
                        ProgressView()
                            .controlSize(.small)
                        Text(L("about.checking"))
                            .foregroundStyle(.secondary)
                    case .upToDate:
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Text(L("about.latest"))
                            .foregroundStyle(.secondary)
                    case .newVersion(let version, let url):
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundStyle(.blue)
                        Text(L("about.newVersion").replacingOccurrences(of: "%@", with: version))
                        Spacer()
                        Link(L("about.download"), destination: url)
                    case .failed:
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                        Text(L("about.checkFailed"))
                            .foregroundStyle(.secondary)
                        Spacer()
                        Button(L("about.checkUpdate")) {
                            Task { await checkForUpdate() }
                        }
                    }
                }
            }
        }
        .formStyle(.grouped)
        .frame(width: 420, height: 220)
    }

    private func checkForUpdate() async {
        updateState = .checking
        do {
            let url = URL(string: "https://api.github.com/repos/mfzzf/todo-list/releases/latest")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let release = try JSONDecoder().decode(GitHubRelease.self, from: data)

            let latest = release.tagName.trimmingCharacters(in: CharacterSet(charactersIn: "vV"))
            if latest == currentVersion {
                updateState = .upToDate
            } else {
                let downloadURL = URL(string: release.htmlURL) ?? URL(string: "https://github.com/mfzzf/todo-list/releases")!
                updateState = .newVersion(latest, downloadURL)
            }
        } catch {
            updateState = .failed
        }
    }
}

// MARK: - Update State

private enum UpdateCheckState {
    case idle
    case checking
    case upToDate
    case newVersion(String, URL)
    case failed
}

// MARK: - GitHub Release Model

private struct GitHubRelease: Decodable {
    let tagName: String
    let htmlURL: String

    enum CodingKeys: String, CodingKey {
        case tagName = "tag_name"
        case htmlURL = "html_url"
    }
}

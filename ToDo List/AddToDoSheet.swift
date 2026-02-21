//
//  AddToDoSheet.swift
//  ToDo List
//
//  Created by Mzzf on 2026/2/21.
//

import SwiftUI
import SwiftData

struct AddToDoSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var notes = ""
    @State private var dueDate: Date = Date()
    @State private var hasDueDate = false
    @State private var priority: Priority = .none
    @State private var categories: [String] = []
    @State private var newCategory = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(L("add.titleHint"), text: $title)
                        .font(.title3)
                }

                Section {
                    Picker(L("detail.priority"), selection: $priority) {
                        ForEach(Priority.allCases) { p in
                            Text(p.label).tag(p)
                        }
                    }
                }

                Section(L("detail.dueDate")) {
                    Toggle(L("detail.setDueDate"), isOn: $hasDueDate)
                    if hasDueDate {
                        DatePicker(L("detail.dueDate"), selection: $dueDate, displayedComponents: .date)
                    }
                }

                Section(L("detail.notes")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 60)
                }

                Section(L("detail.category")) {
                    if !categories.isEmpty {
                        HStack(spacing: 6) {
                            ForEach(categories, id: \.self) { tag in
                                HStack(spacing: 4) {
                                    Text(tag)
                                        .font(.caption)
                                    Button {
                                        categories.removeAll { $0 == tag }
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(.quaternary, in: Capsule())
                            }
                        }
                    }
                    TextField(L("add.categoryHint"), text: $newCategory)
                        .onSubmit {
                            let trimmed = newCategory.trimmingCharacters(in: .whitespaces)
                            if !trimmed.isEmpty && !categories.contains(trimmed) {
                                categories.append(trimmed)
                            }
                            newCategory = ""
                        }
                }
            }
            .formStyle(.grouped)
            .navigationTitle(L("add.title"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L("add.cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(L("add.add")) { save() }
                        .buttonStyle(.glassProminent)
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .frame(minWidth: 420, minHeight: 380)
    }

    private func save() {
        let newItem = Item(
            title: title.trimmingCharacters(in: .whitespaces),
            notes: notes,
            dueDate: hasDueDate ? dueDate : nil,
            priority: priority.rawValue,
            category: categories.joined(separator: ", ")
        )
        modelContext.insert(newItem)
        dismiss()
    }
}

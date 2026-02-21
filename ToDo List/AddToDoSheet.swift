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
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(L("add.title"))
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button(L("add.cancel")) { dismiss() }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                Button(L("add.add")) { save() }
                    .buttonStyle(.glassProminent)
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(24)

            Divider().padding(.horizontal, 24)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Title
                    VStack(alignment: .leading, spacing: 12) {
                        TextField(L("add.titleHint"), text: $title, axis: .vertical)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .textFieldStyle(.plain)
                            .lineLimit(1...3)
                    }
                    .padding(24)

                    Divider().padding(.horizontal, 24)

                    // Properties
                    VStack(alignment: .leading, spacing: 16) {
                        Text(L("detail.properties"))
                            .font(.headline)
                            .foregroundStyle(.secondary)

                        // Priority
                        HStack {
                            Label(L("detail.priority"), systemImage: "flag")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Picker("", selection: $priority) {
                                ForEach(Priority.allCases) { p in
                                    Text(p.label).tag(p)
                                }
                            }
                            .pickerStyle(.segmented)
                            .fixedSize()
                        }

                        Divider()

                        // Categories
                        VStack(alignment: .leading, spacing: 10) {
                            Label(L("detail.category"), systemImage: "tag")
                                .foregroundStyle(.secondary)

                            if !categories.isEmpty {
                                TagFlowLayout(spacing: 6) {
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
                                .textFieldStyle(.plain)
                                .padding(8)
                                .background(.quaternary.opacity(0.3), in: RoundedRectangle(cornerRadius: 8))
                                .onSubmit {
                                    let trimmed = newCategory.trimmingCharacters(in: .whitespaces)
                                    if !trimmed.isEmpty && !categories.contains(trimmed) {
                                        categories.append(trimmed)
                                    }
                                    newCategory = ""
                                }
                        }
                    }
                    .padding(24)

                    Divider().padding(.horizontal, 24)

                    // Notes
                    VStack(alignment: .leading, spacing: 12) {
                        Text(L("detail.notes"))
                            .font(.headline)
                            .foregroundStyle(.secondary)

                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $notes)
                                .font(.body)
                                .scrollContentBackground(.hidden)

                            if notes.isEmpty {
                                Text(L("detail.notesHint"))
                                    .foregroundStyle(.tertiary)
                                    .padding(.top, 8)
                                    .padding(.leading, 5)
                                    .allowsHitTesting(false)
                            }
                        }
                        .padding(12)
                        .frame(minHeight: 80)
                        .background(.quaternary.opacity(0.5), in: RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(24)

                    Divider().padding(.horizontal, 24)

                    // Due Date
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text(L("detail.dueDate"))
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Toggle("", isOn: $hasDueDate.animation(.snappy))
                                .toggleStyle(.switch)
                                .labelsHidden()
                        }

                        if hasDueDate {
                            InlineCalendarView(selectedDate: $dueDate)
                        }
                    }
                    .padding(24)
                }
            }
        }
        .frame(minWidth: 440, minHeight: 500)
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

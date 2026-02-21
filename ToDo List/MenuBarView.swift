//
//  MenuBarView.swift
//  ToDo List
//
//  Created by Mzzf on 2026/2/21.
//

import SwiftUI
import SwiftData

struct MenuBarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Item.creationDate, order: .reverse) private var allItems: [Item]

    private var pendingItems: [Item] {
        allItems.filter { !$0.isCompleted }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text(L("menubar.todos"))
                    .font(.headline)
                Spacer()
                Text("\(pendingItems.count)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(.quaternary, in: Capsule())
            }
            .padding()

            Divider()

            // Items
            if pendingItems.isEmpty {
                Text(L("menubar.noTodos"))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
            } else {
                ScrollView {
                    VStack(spacing: 2) {
                        ForEach(pendingItems.prefix(10)) { item in
                            MenuBarItemRow(item: item)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                }
                .frame(maxHeight: 300)
            }

            Divider()

            // Footer
            HStack {
                Button {
                    NSApp.activate(ignoringOtherApps: true)
                } label: {
                    Label(L("menubar.openApp"), systemImage: "macwindow")
                        .font(.subheadline)
                }
                .buttonStyle(.plain)

                Spacer()

                Button {
                    NSApp.activate(ignoringOtherApps: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        NotificationCenter.default.post(name: .addNewTodo, object: nil)
                    }
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(.glass)

                Button {
                    NSApplication.shared.terminate(nil)
                } label: {
                    Text(L("menubar.quit"))
                        .font(.subheadline)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
            }
            .padding(12)
        }
        .frame(width: 280)
    }
}

private struct MenuBarItemRow: View {
    @Bindable var item: Item

    private var priorityEnum: Priority {
        Priority(rawValue: item.priority) ?? .none
    }

    var body: some View {
        HStack(spacing: 8) {
            Button {
                withAnimation(.snappy) { item.isCompleted.toggle() }
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(item.isCompleted ? .green : .secondary)
                    .contentTransition(.symbolEffect(.replace))
            }
            .buttonStyle(.plain)

            Text(item.title)
                .font(.subheadline)
                .lineLimit(1)

            Spacer()

            if let due = item.dueDate {
                Text(SmartDateFormatter.relativeString(for: due))
                    .font(.caption2)
                    .foregroundStyle(SmartDateFormatter.dueDateColor(for: due, isCompleted: item.isCompleted))
            }

            if priorityEnum != .none {
                Circle()
                    .fill(priorityEnum.color)
                    .frame(width: 6, height: 6)
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(.clear, in: RoundedRectangle(cornerRadius: 6))
    }
}

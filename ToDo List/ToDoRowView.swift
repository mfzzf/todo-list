//
//  ToDoRowView.swift
//  ToDo List
//
//  Created by Mzzf on 2026/2/21.
//

import SwiftUI
import SwiftData

struct ToDoRowView: View {
    @Bindable var item: Item

    private var priorityEnum: Priority {
        Priority(rawValue: item.priority) ?? .none
    }

    private var categories: [String] {
        item.category
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    var body: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation(.snappy) {
                    item.isCompleted.toggle()
                }
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(item.isCompleted ? .green : .secondary)
                    .contentTransition(.symbolEffect(.replace))
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 3) {
                Text(item.title)
                    .strikethrough(item.isCompleted)
                    .foregroundStyle(item.isCompleted ? .secondary : .primary)
                    .font(.body)

                HStack(spacing: 6) {
                    if let due = item.dueDate {
                        Label(
                            SmartDateFormatter.relativeString(for: due),
                            systemImage: "calendar"
                        )
                        .font(.caption)
                        .foregroundStyle(SmartDateFormatter.dueDateColor(for: due, isCompleted: item.isCompleted))
                    }

                    ForEach(categories, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.quaternary, in: Capsule())
                    }
                }
            }

            Spacer()

            if priorityEnum != .none {
                Image(systemName: priorityEnum.symbolName)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(priorityEnum.color)
                    .frame(width: 20, height: 20)
            }
        }
        .padding(.vertical, 4)
        .opacity(item.isCompleted ? 0.7 : 1.0)
    }
}

//
//  ToDoListView.swift
//  ToDo List
//
//  Created by Mzzf on 2026/2/21.
//

import SwiftUI
import SwiftData

struct ToDoListView: View {
    @Environment(\.modelContext) private var modelContext
    let filter: SidebarFilter
    let searchText: String
    @Binding var selectedItem: Item?

    @Query(sort: \Item.creationDate, order: .reverse) private var allItems: [Item]

    @State private var sortOrder: SortOrder = .dueDate

    enum SortOrder: String, CaseIterable {
        case dueDate
        case priority
        case creationDate

        var label: String {
            switch self {
            case .dueDate:      return L("sort.dueDate")
            case .priority:     return L("sort.priority")
            case .creationDate: return L("sort.creationDate")
            }
        }
    }

    // MARK: - Filtering

    private func applySearchAndSort(_ items: [Item]) -> [Item] {
        var result = items

        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.notes.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText)
            }
        }

        switch sortOrder {
        case .dueDate:
            result.sort { ($0.dueDate ?? .distantFuture) < ($1.dueDate ?? .distantFuture) }
        case .priority:
            result.sort { $0.priority > $1.priority }
        case .creationDate:
            result.sort { $0.creationDate > $1.creationDate }
        }

        return result
    }

    private var uncompletedItems: [Item] {
        let base: [Item]
        let calendar = Calendar.current
        switch filter {
        case .all:
            base = allItems.filter { !$0.isCompleted }
        case .today:
            base = allItems.filter { item in
                guard let due = item.dueDate else { return false }
                return calendar.isDateInToday(due) && !item.isCompleted
            }
        case .upcoming:
            base = allItems.filter { item in
                guard let due = item.dueDate else { return false }
                return due >= calendar.startOfDay(for: Date()) && !item.isCompleted
            }
        case .completed:
            return []
        }
        return applySearchAndSort(base)
    }

    private var completedItems: [Item] {
        switch filter {
        case .all:
            return applySearchAndSort(allItems.filter { $0.isCompleted })
        case .completed:
            return applySearchAndSort(allItems.filter { $0.isCompleted })
        default:
            return []
        }
    }

    private var hasAnyItems: Bool {
        !uncompletedItems.isEmpty || !completedItems.isEmpty
    }

    // MARK: - Body

    var body: some View {
        List(selection: $selectedItem) {
            if filter == .all {
                // 上方：未完成
                Section {
                    ForEach(uncompletedItems) { item in
                        ToDoRowView(item: item).tag(item)
                    }
                    .onDelete { offsets in deleteItems(from: uncompletedItems, at: offsets) }
                } header: {
                    Text(L("list.uncompleted"))
                }

                // 下方：已完成
                if !completedItems.isEmpty {
                    Section {
                        ForEach(completedItems) { item in
                            ToDoRowView(item: item).tag(item)
                        }
                        .onDelete { offsets in deleteItems(from: completedItems, at: offsets) }
                    } header: {
                        Text(L("list.completed"))
                    }
                }
            } else if filter == .completed {
                ForEach(completedItems) { item in
                    ToDoRowView(item: item).tag(item)
                }
                .onDelete { offsets in deleteItems(from: completedItems, at: offsets) }
            } else {
                ForEach(uncompletedItems) { item in
                    ToDoRowView(item: item).tag(item)
                }
                .onDelete { offsets in deleteItems(from: uncompletedItems, at: offsets) }
            }
        }
        .navigationSplitViewColumnWidth(min: 250, ideal: 350)
        .overlay {
            if !hasAnyItems {
                ContentUnavailableView(
                    L("list.empty"),
                    systemImage: "checklist",
                    description: Text(L("list.emptyHint"))
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Menu {
                    Picker(L("sort.by"), selection: $sortOrder) {
                        ForEach(SortOrder.allCases, id: \.self) { order in
                            Text(order.label).tag(order)
                        }
                    }
                } label: {
                    Label(L("sort.label"), systemImage: "arrow.up.arrow.down")
                }
                .buttonStyle(.glass)
            }
        }
    }

    private func deleteItems(from source: [Item], at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(source[index])
            }
            if let selected = selectedItem, !allItems.contains(where: { $0.id == selected.id }) {
                selectedItem = nil
            }
        }
    }
}

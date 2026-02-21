//
//  ContentView.swift
//  ToDo List
//
//  Created by Mzzf on 2026/2/21.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedFilter: SidebarFilter = .all
    @State private var selectedItem: Item?
    @State private var searchText = ""
    @State private var showingAddSheet = false

    var body: some View {
        NavigationSplitView {
            SidebarView(
                selectedFilter: $selectedFilter,
                searchText: $searchText,
                showingAddSheet: $showingAddSheet
            )
        } content: {
            ToDoListView(
                filter: selectedFilter,
                searchText: searchText,
                selectedItem: $selectedItem
            )
            .navigationTitle(selectedFilter.label)
        } detail: {
            Group {
                if let selectedItem {
                    DetailView(item: selectedItem)
                } else {
                    ContentUnavailableView(
                        L("detail.selectTodo"),
                        systemImage: "sidebar.right",
                        description: Text(L("detail.selectHint"))
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(.glass)
                }
            }
        }
        .toolbar(removing: .sidebarToggle)
        .sheet(isPresented: $showingAddSheet) {
            AddToDoSheet()
        }
        .onReceive(NotificationCenter.default.publisher(for: .addNewTodo)) { _ in
            showingAddSheet = true
        }
        .frame(minWidth: 700, minHeight: 450)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

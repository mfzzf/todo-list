//
//  SidebarView.swift
//  ToDo List
//
//  Created by Mzzf on 2026/2/21.
//

import SwiftUI

enum SidebarFilter: String, Hashable, CaseIterable, Identifiable {
    case all
    case today
    case upcoming
    case completed

    var id: String { rawValue }

    var label: String {
        switch self {
        case .all:       return L("filter.all")
        case .today:     return L("filter.today")
        case .upcoming:  return L("filter.upcoming")
        case .completed: return L("filter.completed")
        }
    }

    var systemImage: String {
        switch self {
        case .all:       return "tray.full"
        case .today:     return "sun.max"
        case .upcoming:  return "calendar"
        case .completed: return "checkmark.circle"
        }
    }

    var tintColor: Color {
        switch self {
        case .all:       return .blue
        case .today:     return .orange
        case .upcoming:  return .purple
        case .completed: return .green
        }
    }
}

struct SidebarView: View {
    @Binding var selectedFilter: SidebarFilter
    @Binding var searchText: String
    @Binding var showingAddSheet: Bool

    var body: some View {
        List(selection: $selectedFilter) {
            Section(L("sidebar.filters")) {
                ForEach(SidebarFilter.allCases) { filter in
                    Label(filter.label, systemImage: filter.systemImage)
                        .foregroundStyle(filter.tintColor)
                        .tag(filter)
                }
            }
        }
        .navigationSplitViewColumnWidth(min: 180, ideal: 220)
        .searchable(text: $searchText, placement: .sidebar, prompt: Text(L("sidebar.search")))
    }
}

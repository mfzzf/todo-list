//
//  Priority.swift
//  ToDo List
//
//  Created by Mzzf on 2026/2/21.
//

import SwiftUI

enum Priority: Int, CaseIterable, Identifiable, Codable {
    case none = 0
    case low = 1
    case medium = 2
    case high = 3

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .none:   return L("priority.none")
        case .low:    return L("priority.low")
        case .medium: return L("priority.medium")
        case .high:   return L("priority.high")
        }
    }

    var color: Color {
        switch self {
        case .none:   return .secondary
        case .low:    return .blue
        case .medium: return .orange
        case .high:   return .red
        }
    }

    var symbolName: String {
        switch self {
        case .none:   return "minus"
        case .low:    return "1.circle"
        case .medium: return "2.circle"
        case .high:   return "3.circle.fill"
        }
    }
}

//
//  Item.swift
//  ToDo List
//
//  Created by Mzzf on 2026/2/21.
//

import Foundation
import SwiftData

@Model
final class Item {
    var title: String
    var notes: String
    var isCompleted: Bool
    var creationDate: Date
    var dueDate: Date?
    var priority: Int
    var category: String

    var isOverdue: Bool {
        guard let due = dueDate, !isCompleted else { return false }
        return due < Calendar.current.startOfDay(for: Date())
    }

    init(
        title: String,
        notes: String = "",
        isCompleted: Bool = false,
        dueDate: Date? = nil,
        priority: Int = 0,
        category: String = ""
    ) {
        self.title = title
        self.notes = notes
        self.isCompleted = isCompleted
        self.creationDate = Date()
        self.dueDate = dueDate
        self.priority = priority
        self.category = category
    }
}

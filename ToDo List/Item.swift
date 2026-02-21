//
//  Item.swift
//  ToDo List
//
//  Created by Mzzf on 2026/2/21.
//

import Foundation
import SwiftData

struct AttachmentInfo: Codable, Identifiable, Hashable {
    let id: UUID
    let bookmarkData: Data
    let originalPath: String
    let addedDate: Date

    var fileName: String { (originalPath as NSString).lastPathComponent }
    var fileExtension: String { (originalPath as NSString).pathExtension.lowercased() }
}

@Model
final class Item {
    var title: String
    var notes: String
    var isCompleted: Bool
    var creationDate: Date
    var dueDate: Date?
    var priority: Int
    var category: String
    var attachments: String = "[]"

    var isOverdue: Bool {
        guard let due = dueDate, !isCompleted else { return false }
        return due < Calendar.current.startOfDay(for: Date())
    }

    var attachmentList: [AttachmentInfo] {
        get {
            guard let data = attachments.data(using: .utf8) else { return [] }
            return (try? JSONDecoder().decode([AttachmentInfo].self, from: data)) ?? []
        }
        set {
            if let data = try? JSONEncoder().encode(newValue),
               let json = String(data: data, encoding: .utf8) {
                attachments = json
            }
        }
    }

    @discardableResult
    func addAttachment(url: URL) -> Bool {
        let path = url.path
        if attachmentList.contains(where: { $0.originalPath == path }) { return false }

        guard let bookmark = try? url.bookmarkData(
            options: .withSecurityScope,
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        ) else { return false }

        let info = AttachmentInfo(
            id: UUID(),
            bookmarkData: bookmark,
            originalPath: path,
            addedDate: Date()
        )
        var list = attachmentList
        list.append(info)
        attachmentList = list
        return true
    }

    func removeAttachment(_ attachment: AttachmentInfo) {
        var list = attachmentList
        list.removeAll { $0.id == attachment.id }
        attachmentList = list
    }

    func resolveAttachmentURL(_ attachment: AttachmentInfo) -> URL? {
        var isStale = false
        guard let url = try? URL(
            resolvingBookmarkData: attachment.bookmarkData,
            options: .withSecurityScope,
            relativeTo: nil,
            bookmarkDataIsStale: &isStale
        ) else { return nil }
        return url
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

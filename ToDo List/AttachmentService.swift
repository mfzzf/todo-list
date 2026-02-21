//
//  AttachmentService.swift
//  ToDo List
//
//  Created by Mzzf on 2026/2/21.
//

import AppKit

enum AttachmentService {
    static func openFile(url: URL) {
        let accessing = url.startAccessingSecurityScopedResource()
        NSWorkspace.shared.open(url)
        if accessing { url.stopAccessingSecurityScopedResource() }
    }

    static func showInFinder(url: URL) {
        let accessing = url.startAccessingSecurityScopedResource()
        NSWorkspace.shared.activateFileViewerSelecting([url])
        if accessing { url.stopAccessingSecurityScopedResource() }
    }
}

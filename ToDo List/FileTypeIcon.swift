//
//  FileTypeIcon.swift
//  ToDo List
//
//  Created by Mzzf on 2026/2/21.
//

import SwiftUI

enum FileTypeIcon {
    static func symbolName(for ext: String) -> String {
        switch ext {
        case "pdf":
            return "doc.richtext"
        case "doc", "docx", "rtf", "pages":
            return "doc.text"
        case "txt", "md":
            return "doc.plaintext"
        case "xls", "xlsx", "csv", "numbers":
            return "tablecells"
        case "ppt", "pptx", "key":
            return "rectangle.on.rectangle.angled"
        case "jpg", "jpeg", "png", "gif", "heic", "svg", "webp", "tiff", "bmp":
            return "photo"
        case "mp4", "mov", "avi", "mkv", "wmv", "flv":
            return "film"
        case "mp3", "wav", "aac", "flac", "m4a", "ogg":
            return "waveform"
        case "zip", "rar", "7z", "dmg", "tar", "gz":
            return "doc.zipper"
        case "swift", "py", "js", "ts", "html", "css", "json", "xml", "java", "c", "cpp", "go", "rb", "rs", "sh":
            return "chevron.left.forwardslash.chevron.right"
        default:
            return "doc"
        }
    }

    static func color(for ext: String) -> Color {
        switch ext {
        case "pdf":
            return .red
        case "doc", "docx", "rtf", "pages", "txt", "md":
            return .blue
        case "xls", "xlsx", "csv", "numbers":
            return .green
        case "ppt", "pptx", "key":
            return .orange
        case "jpg", "jpeg", "png", "gif", "heic", "svg", "webp", "tiff", "bmp":
            return .purple
        case "mp4", "mov", "avi", "mkv", "wmv", "flv":
            return .pink
        case "mp3", "wav", "aac", "flac", "m4a", "ogg":
            return .indigo
        case "zip", "rar", "7z", "dmg", "tar", "gz":
            return .brown
        case "swift", "py", "js", "ts", "html", "css", "json", "xml", "java", "c", "cpp", "go", "rb", "rs", "sh":
            return .mint
        default:
            return .secondary
        }
    }
}

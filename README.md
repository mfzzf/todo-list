<p align="right">
  <a href="README.md">English</a> | <a href="README_zh.md">中文</a>
</p>

<p align="center">
  <img src="assets/icon.png" width="128" height="128" alt="ToDo List Icon">
</p>

<h1 align="center">ToDo List</h1>

<p align="center">
  A modern, feature-rich todo app for macOS built with SwiftUI and SwiftData.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/platform-macOS%2026.2+-blue" alt="Platform">
  <img src="https://img.shields.io/badge/swift-5.0+-orange" alt="Swift">
  <img src="https://img.shields.io/badge/license-Apache%202.0-green" alt="License">
</p>

---

## Screenshots

| Main Interface | Menu Bar |
|:-:|:-:|
| ![Main](assets/example1.png) | ![Menu Bar](assets/menubar.png) |

## Features

- **Three-Column Layout** — Sidebar filters, task list, and detail editor in a clean NavigationSplitView.
- **Priority & Categories** — Set priority levels (None / Low / Medium / High) and assign multiple tags to each task.
- **Due Dates** — Inline calendar picker with smart relative date display (Today, Tomorrow, Overdue, etc.).
- **Markdown Notes** — Write notes in Markdown and preview rendered output with full block-level support (headings, lists, code blocks, tables) powered by [MarkdownUI](https://github.com/gonzalezreal/swift-markdown-ui).
- **File Attachments** — Attach files via drag-and-drop or file picker. Open files or reveal in Finder with one click. Security-scoped bookmarks ensure persistent access across app launches.
- **Smart Filtering** — Filter by All / Today / Upcoming / Completed. Sort by due date, priority, or creation date. Full-text search across titles, notes, and categories.
- **Menu Bar Quick Access** — View and manage pending tasks directly from the macOS menu bar without opening the main window.
- **Multilingual** — Full support for English, Chinese (中文), and Japanese (日本語).
- **Keyboard Shortcuts** — `⌘N` to create a new task, and more.
- **Persistent Storage** — SwiftData powers reliable local data persistence with automatic lightweight migration.

## Requirements

- macOS 26.2+
- Xcode 26.2+

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/mfzzf/todo-list.git
   ```
2. Open `ToDo List.xcodeproj` in Xcode.
3. Wait for Swift Package Manager to resolve dependencies.
4. Build and run (`⌘R`).

## Dependencies

| Package | Purpose |
|---------|---------|
| [MarkdownUI](https://github.com/gonzalezreal/swift-markdown-ui) | Markdown rendering in SwiftUI |

## Architecture

```
ToDo List/
├── ToDo_ListApp.swift        # App entry point & MenuBarExtra
├── ContentView.swift         # Three-column NavigationSplitView
├── SidebarView.swift         # Filter navigation (All/Today/Upcoming/Completed)
├── ToDoListView.swift        # Task list with search & sort
├── ToDoRowView.swift         # Individual task row
├── DetailView.swift          # Task detail editor
├── AddToDoSheet.swift        # New task creation sheet
├── MenuBarView.swift         # Menu bar popover
├── SettingsView.swift        # App preferences
├── Item.swift                # SwiftData model
├── Priority.swift            # Priority enum
├── Localization.swift        # i18n (EN/ZH/JA)
├── DateFormatting.swift      # Smart date utilities
├── AttachmentService.swift   # File open & Finder reveal
├── FileTypeIcon.swift        # File extension → SF Symbol mapping
└── Assets.xcassets/          # Colors & icons
```

## License

Apache License 2.0. See [LICENSE](LICENSE) for details.

---

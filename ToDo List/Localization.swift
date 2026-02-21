//
//  Localization.swift
//  ToDo List
//
//  Created by Mzzf on 2026/2/21.
//

import Foundation
import SwiftUI

// MARK: - Language

enum AppLanguage: String, CaseIterable, Identifiable {
    case system = "system"
    case zhHans = "zh-Hans"
    case en = "en"
    case ja = "ja"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .system: return "跟随系统 / System"
        case .zhHans: return "简体中文"
        case .en:     return "English"
        case .ja:     return "日本語"
        }
    }

    var resolved: AppLanguage {
        guard self == .system else { return self }
        let preferred = Locale.preferredLanguages.first ?? "en"
        if preferred.hasPrefix("zh") { return .zhHans }
        if preferred.hasPrefix("ja") { return .ja }
        return .en
    }
}

// MARK: - Settings

@Observable
class AppSettings {
    static let shared = AppSettings()

    var language: AppLanguage {
        didSet { UserDefaults.standard.set(language.rawValue, forKey: "appLanguage") }
    }

    var resolvedLanguage: AppLanguage { language.resolved }

    private init() {
        let saved = UserDefaults.standard.string(forKey: "appLanguage") ?? AppLanguage.system.rawValue
        self.language = AppLanguage(rawValue: saved) ?? .system
    }
}

// MARK: - Lookup

func L(_ key: String) -> String {
    let lang = AppSettings.shared.resolvedLanguage
    return L10n.strings[lang]?[key] ?? L10n.strings[.zhHans]?[key] ?? key
}

// MARK: - Strings

enum L10n {
    static let strings: [AppLanguage: [String: String]] = [
        .zhHans: zhHans,
        .en: en,
        .ja: ja,
    ]

    private static let zhHans: [String: String] = [
        // Sidebar
        "sidebar.filters":       "筛选",
        "filter.all":            "全部",
        "filter.today":          "今天",
        "filter.upcoming":       "即将到来",
        "filter.completed":      "已完成",
        "sidebar.search":        "搜索待办...",
        "sidebar.addTodo":       "新建待办",

        // List
        "sort.dueDate":          "截止日期",
        "sort.priority":         "优先级",
        "sort.creationDate":     "创建时间",
        "sort.label":            "排序",
        "sort.by":               "排序方式",
        "list.empty":            "暂无待办",
        "list.emptyHint":        "点击 + 添加新的待办事项",
        "list.uncompleted":      "未完成",
        "list.completed":        "已完成",

        // Detail
        "detail.title":          "标题",
        "detail.properties":     "属性",
        "detail.status":         "状态",
        "detail.completed":      "已完成",
        "detail.inProgress":     "进行中",
        "detail.priority":       "优先级",
        "detail.category":       "分类",
        "detail.categoryHint":   "添加分类...",
        "detail.dueDate":        "截止日期",
        "detail.setDueDate":     "设置截止日期",
        "detail.notes":          "备注",
        "detail.notesHint":      "支持 Markdown 语法...",
        "detail.notesEdit":      "编辑",
        "detail.notesPreview":   "预览",
        "detail.createdAt":      "创建于",
        "detail.overdue":        "已逾期",
        "detail.delete":         "删除待办",
        "detail.deleteConfirm":  "确定要删除这个待办吗？",
        "detail.deleteAction":   "删除",
        "row.copy":              "复制",
        "row.delete":            "删除",
        "detail.markIncomplete": "标记为未完成",
        "detail.markComplete":   "标记为完成",
        "detail.selectTodo":     "选择一个待办",
        "detail.selectHint":     "从列表中选择一个待办事项来查看详情",

        // Add
        "add.titleHint":         "你需要做什么？",
        "add.cancel":            "取消",
        "add.add":               "添加",
        "add.title":             "新建待办",
        "add.categoryHint":      "例如：工作、个人、购物",

        // Priority
        "priority.none":         "无",
        "priority.low":          "低",
        "priority.medium":       "中",
        "priority.high":         "高",
        "priority.suffix":       "优先级",

        // Date
        "date.today":            "今天",
        "date.tomorrow":         "明天",
        "date.yesterday":        "昨天",

        // Settings
        "settings.title":        "设置",
        "settings.language":     "语言",
        "settings.general":      "通用",

        // Menu Bar
        "menubar.todos":         "待办事项",
        "menubar.noTodos":       "暂无待办",
        "menubar.openApp":       "打开应用",
        "menubar.quit":          "退出",

        // Attachment
        "attachment.title":      "附件",
        "attachment.add":        "添加文件",
        "attachment.dropHint":   "拖放文件到此处，或点击添加",
        "attachment.open":       "打开文件",
        "attachment.showInFinder": "在 Finder 中显示",
        "attachment.remove":     "移除附件",
        "attachment.pickMessage": "选择要附加的文件",
        "attachment.pickPrompt": "附加",

        // Command
        "command.newTodo":       "新建待办",

        // About
        "about.title":           "关于",
        "about.version":         "当前版本",
        "about.checkUpdate":     "检查更新",
        "about.checking":        "检查中...",
        "about.latest":          "已是最新版本",
        "about.newVersion":      "发现新版本: %@",
        "about.download":        "前往下载",
        "about.checkFailed":     "检查失败",
    ]

    private static let en: [String: String] = [
        "sidebar.filters":       "Filters",
        "filter.all":            "All",
        "filter.today":          "Today",
        "filter.upcoming":       "Upcoming",
        "filter.completed":      "Completed",
        "sidebar.search":        "Search todos...",
        "sidebar.addTodo":       "New Todo",

        "sort.dueDate":          "Due Date",
        "sort.priority":         "Priority",
        "sort.creationDate":     "Date Created",
        "sort.label":            "Sort",
        "sort.by":               "Sort By",
        "list.empty":            "No Todos",
        "list.emptyHint":        "Tap + to add a new todo",
        "list.uncompleted":      "Active",
        "list.completed":        "Completed",

        "detail.title":          "Title",
        "detail.properties":     "Properties",
        "detail.status":         "Status",
        "detail.completed":      "Completed",
        "detail.inProgress":     "In Progress",
        "detail.priority":       "Priority",
        "detail.category":       "Category",
        "detail.categoryHint":   "Add category...",
        "detail.dueDate":        "Due Date",
        "detail.setDueDate":     "Set Due Date",
        "detail.notes":          "Notes",
        "detail.notesHint":      "Supports Markdown...",
        "detail.notesEdit":      "Edit",
        "detail.notesPreview":   "Preview",
        "detail.createdAt":      "Created",
        "detail.overdue":        "Overdue",
        "detail.delete":         "Delete Todo",
        "detail.deleteConfirm":  "Delete this todo?",
        "detail.deleteAction":   "Delete",
        "row.copy":              "Copy",
        "row.delete":            "Delete",
        "detail.markIncomplete": "Mark Incomplete",
        "detail.markComplete":   "Mark Complete",
        "detail.selectTodo":     "Select a Todo",
        "detail.selectHint":     "Choose a todo from the list to view details",

        "add.titleHint":         "What do you need to do?",
        "add.cancel":            "Cancel",
        "add.add":               "Add",
        "add.title":             "New Todo",
        "add.categoryHint":      "e.g. Work, Personal, Shopping",

        "priority.none":         "None",
        "priority.low":          "Low",
        "priority.medium":       "Medium",
        "priority.high":         "High",
        "priority.suffix":       "Priority",

        "date.today":            "Today",
        "date.tomorrow":         "Tomorrow",
        "date.yesterday":        "Yesterday",

        "settings.title":        "Settings",
        "settings.language":     "Language",
        "settings.general":      "General",

        "menubar.todos":         "Todos",
        "menubar.noTodos":       "No pending todos",
        "menubar.openApp":       "Open App",
        "menubar.quit":          "Quit",

        "attachment.title":      "Attachments",
        "attachment.add":        "Add File",
        "attachment.dropHint":   "Drop files here, or click to add",
        "attachment.open":       "Open File",
        "attachment.showInFinder": "Show in Finder",
        "attachment.remove":     "Remove Attachment",
        "attachment.pickMessage": "Choose files to attach",
        "attachment.pickPrompt": "Attach",

        "command.newTodo":       "New Todo",

        // About
        "about.title":           "About",
        "about.version":         "Current Version",
        "about.checkUpdate":     "Check for Updates",
        "about.checking":        "Checking...",
        "about.latest":          "You're up to date",
        "about.newVersion":      "New version available: %@",
        "about.download":        "Download",
        "about.checkFailed":     "Check failed",
    ]

    private static let ja: [String: String] = [
        "sidebar.filters":       "フィルター",
        "filter.all":            "すべて",
        "filter.today":          "今日",
        "filter.upcoming":       "予定",
        "filter.completed":      "完了済み",
        "sidebar.search":        "タスクを検索...",
        "sidebar.addTodo":       "新規タスク",

        "sort.dueDate":          "期限",
        "sort.priority":         "優先度",
        "sort.creationDate":     "作成日",
        "sort.label":            "並べ替え",
        "sort.by":               "並べ替え",
        "list.empty":            "タスクなし",
        "list.emptyHint":        "+をタップして新しいタスクを追加",
        "list.uncompleted":      "未完了",
        "list.completed":        "完了済み",

        "detail.title":          "タイトル",
        "detail.properties":     "プロパティ",
        "detail.status":         "ステータス",
        "detail.completed":      "完了",
        "detail.inProgress":     "進行中",
        "detail.priority":       "優先度",
        "detail.category":       "カテゴリ",
        "detail.categoryHint":   "カテゴリを追加...",
        "detail.dueDate":        "期限",
        "detail.setDueDate":     "期限を設定",
        "detail.notes":          "メモ",
        "detail.notesHint":      "Markdown に対応...",
        "detail.notesEdit":      "編集",
        "detail.notesPreview":   "プレビュー",
        "detail.createdAt":      "作成日",
        "detail.overdue":        "期限切れ",
        "detail.delete":         "タスクを削除",
        "detail.deleteConfirm":  "このタスクを削除しますか？",
        "detail.deleteAction":   "削除",
        "row.copy":              "コピー",
        "row.delete":            "削除",
        "detail.markIncomplete": "未完了にする",
        "detail.markComplete":   "完了にする",
        "detail.selectTodo":     "タスクを選択",
        "detail.selectHint":     "リストからタスクを選択してください",

        "add.titleHint":         "何をしますか？",
        "add.cancel":            "キャンセル",
        "add.add":               "追加",
        "add.title":             "新規タスク",
        "add.categoryHint":      "例：仕事、個人、買い物",

        "priority.none":         "なし",
        "priority.low":          "低",
        "priority.medium":       "中",
        "priority.high":         "高",
        "priority.suffix":       "優先",

        "date.today":            "今日",
        "date.tomorrow":         "明日",
        "date.yesterday":        "昨日",

        "settings.title":        "設定",
        "settings.language":     "言語",
        "settings.general":      "一般",

        "menubar.todos":         "タスク",
        "menubar.noTodos":       "未完了のタスクなし",
        "menubar.openApp":       "アプリを開く",
        "menubar.quit":          "終了",

        "attachment.title":      "添付ファイル",
        "attachment.add":        "ファイルを追加",
        "attachment.dropHint":   "ここにファイルをドロップ、またはクリックして追加",
        "attachment.open":       "ファイルを開く",
        "attachment.showInFinder": "Finder で表示",
        "attachment.remove":     "添付を削除",
        "attachment.pickMessage": "添付するファイルを選択",
        "attachment.pickPrompt": "添付",

        "command.newTodo":       "新規タスク",

        // About
        "about.title":           "バージョン情報",
        "about.version":         "現在のバージョン",
        "about.checkUpdate":     "アップデートを確認",
        "about.checking":        "確認中...",
        "about.latest":          "最新バージョンです",
        "about.newVersion":      "新しいバージョン: %@",
        "about.download":        "ダウンロード",
        "about.checkFailed":     "確認に失敗しました",
    ]
}

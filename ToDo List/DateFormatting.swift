//
//  DateFormatting.swift
//  ToDo List
//
//  Created by Mzzf on 2026/2/21.
//

import SwiftUI

enum SmartDateFormatter {
    static func relativeString(for date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date)     { return L("date.today") }
        if calendar.isDateInTomorrow(date)  { return L("date.tomorrow") }
        if calendar.isDateInYesterday(date) { return L("date.yesterday") }

        let daysAway = calendar.dateComponents(
            [.day],
            from: calendar.startOfDay(for: Date()),
            to: calendar.startOfDay(for: date)
        ).day ?? 0

        let formatter = DateFormatter()
        let lang = AppSettings.shared.resolvedLanguage
        switch lang {
        case .en: formatter.locale = Locale(identifier: "en_US")
        case .ja: formatter.locale = Locale(identifier: "ja_JP")
        default:  formatter.locale = Locale(identifier: "zh_CN")
        }

        if daysAway > 0 && daysAway < 7 {
            formatter.dateFormat = "EEEE"
        } else {
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
        }
        return formatter.string(from: date)
    }

    static func dueDateColor(for date: Date, isCompleted: Bool) -> Color {
        if isCompleted { return .secondary }
        let calendar = Calendar.current
        if date < calendar.startOfDay(for: Date()) { return .red }
        if calendar.isDateInToday(date) { return .orange }
        return .primary
    }
}

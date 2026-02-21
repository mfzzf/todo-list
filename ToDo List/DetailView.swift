//
//  DetailView.swift
//  ToDo List
//
//  Created by Mzzf on 2026/2/21.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    @Bindable var item: Item
    @Environment(\.modelContext) private var modelContext
    @State private var showDeleteConfirmation = false
    @State private var newCategory = ""

    private var priorityEnum: Priority {
        Priority(rawValue: item.priority) ?? .none
    }

    private var categories: [String] {
        item.category
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                headerSection
                Divider().padding(.horizontal, 24)
                propertiesSection
                Divider().padding(.horizontal, 24)
                notesSection
                Divider().padding(.horizontal, 24)
                dateSection
                Spacer(minLength: 24)
                footerSection
            }
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    withAnimation(.snappy) { item.isCompleted.toggle() }
                } label: {
                    Label(
                        item.isCompleted ? L("detail.markIncomplete") : L("detail.markComplete"),
                        systemImage: item.isCompleted ? "arrow.uturn.backward.circle" : "checkmark.circle"
                    )
                }
                .buttonStyle(.glass)
            }
        }
        .confirmationDialog(L("detail.deleteConfirm"), isPresented: $showDeleteConfirmation) {
            Button(L("detail.deleteAction"), role: .destructive) {
                modelContext.delete(item)
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                if item.isCompleted {
                    statusBadge(L("detail.completed"), color: .green, icon: "checkmark.circle.fill")
                } else if item.isOverdue {
                    statusBadge(L("detail.overdue"), color: .red, icon: "exclamationmark.triangle.fill")
                }

                if priorityEnum != .none {
                    statusBadge(
                        priorityEnum.label + " " + L("priority.suffix"),
                        color: priorityEnum.color,
                        icon: priorityEnum.symbolName
                    )
                }

                ForEach(categories, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.quaternary, in: Capsule())
                }

                Spacer()
            }

            TextField(L("detail.title"), text: $item.title, axis: .vertical)
                .font(.title)
                .fontWeight(.bold)
                .textFieldStyle(.plain)
                .lineLimit(1...3)

            Text("\(L("detail.createdAt")) \(item.creationDate, style: .date)")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(24)
    }

    // MARK: - Properties

    private var propertiesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L("detail.properties"))
                .font(.headline)
                .foregroundStyle(.secondary)

            // 状态
            HStack {
                Label(L("detail.status"), systemImage: "circle.dashed")
                    .foregroundStyle(.secondary)
                Spacer()
                Toggle("", isOn: $item.isCompleted.animation(.snappy))
                    .toggleStyle(.switch)
                    .labelsHidden()
                Text(item.isCompleted ? L("detail.completed") : L("detail.inProgress"))
                    .font(.subheadline)
                    .foregroundStyle(item.isCompleted ? .green : .primary)
            }

            Divider()

            // 优先级 — fixedSize 让 picker 按内容自适应宽度，解决中文空隙问题
            HStack {
                Label(L("detail.priority"), systemImage: "flag")
                    .foregroundStyle(.secondary)
                Spacer()
                Picker("", selection: Binding(
                    get: { Priority(rawValue: item.priority) ?? .none },
                    set: { item.priority = $0.rawValue }
                )) {
                    ForEach(Priority.allCases) { p in
                        Text(p.label).tag(p)
                    }
                }
                .pickerStyle(.segmented)
                .fixedSize()
            }

            Divider()

            // 分类 — 多标签，回车添加
            VStack(alignment: .leading, spacing: 10) {
                Label(L("detail.category"), systemImage: "tag")
                    .foregroundStyle(.secondary)

                if !categories.isEmpty {
                    TagFlowLayout(spacing: 6) {
                        ForEach(categories, id: \.self) { tag in
                            HStack(spacing: 4) {
                                Text(tag)
                                    .font(.caption)
                                Button {
                                    removeCategory(tag)
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(.quaternary, in: Capsule())
                        }
                    }
                }

                TextField(L("detail.categoryHint"), text: $newCategory)
                    .textFieldStyle(.plain)
                    .padding(8)
                    .background(.quaternary.opacity(0.3), in: RoundedRectangle(cornerRadius: 8))
                    .onSubmit { addCategory() }
            }
        }
        .padding(24)
    }

    // MARK: - Date

    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(L("detail.dueDate"))
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Spacer()
                Toggle("", isOn: Binding(
                    get: { item.dueDate != nil },
                    set: { newValue in
                        withAnimation(.snappy) {
                            item.dueDate = newValue ? (item.dueDate ?? Date()) : nil
                        }
                    }
                ))
                .toggleStyle(.switch)
                .labelsHidden()
            }

            if item.dueDate != nil {
                InlineCalendarView(
                    selectedDate: Binding(
                        get: { item.dueDate ?? Date() },
                        set: { item.dueDate = $0 }
                    )
                )

                if let due = item.dueDate {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                        Text(SmartDateFormatter.relativeString(for: due))
                            .fontWeight(.medium)
                    }
                    .font(.subheadline)
                    .foregroundStyle(SmartDateFormatter.dueDateColor(for: due, isCompleted: item.isCompleted))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        SmartDateFormatter.dueDateColor(for: due, isCompleted: item.isCompleted).opacity(0.1),
                        in: RoundedRectangle(cornerRadius: 8)
                    )
                }
            }
        }
        .padding(24)
    }

    // MARK: - Notes（修复 placeholder 对齐）

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L("detail.notes"))
                .font(.headline)
                .foregroundStyle(.secondary)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $item.notes)
                    .font(.body)
                    .scrollContentBackground(.hidden)

                if item.notes.isEmpty {
                    Text(L("detail.notesHint"))
                        .foregroundStyle(.tertiary)
                        .padding(.top, 8)
                        .padding(.leading, 5)
                        .allowsHitTesting(false)
                }
            }
            .padding(12)
            .frame(minHeight: 120)
            .background(.quaternary.opacity(0.5), in: RoundedRectangle(cornerRadius: 10))
        }
        .padding(24)
    }

    // MARK: - Footer（删除按钮放右侧，字号加大）

    private var footerSection: some View {
        HStack {
            Spacer()
            Button(role: .destructive) {
                showDeleteConfirmation = true
            } label: {
                Label(L("detail.delete"), systemImage: "trash")
                    .font(.body)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.red.opacity(0.8))
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }

    // MARK: - Category Helpers

    private func addCategory() {
        let trimmed = newCategory.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        var current = categories
        if !current.contains(trimmed) {
            current.append(trimmed)
        }
        item.category = current.joined(separator: ", ")
        newCategory = ""
    }

    private func removeCategory(_ tag: String) {
        var current = categories
        current.removeAll { $0 == tag }
        item.category = current.joined(separator: ", ")
    }

    // MARK: - Components

    private func statusBadge(_ text: String, color: Color, icon: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundStyle(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.12), in: Capsule())
    }
}

// MARK: - Custom Calendar

private struct InlineCalendarView: View {
    @Binding var selectedDate: Date
    @State private var displayedMonth: Date

    private let calendar = Calendar.current

    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        self._displayedMonth = State(initialValue: selectedDate.wrappedValue)
    }

    private var weekdaySymbols: [String] {
        let formatter = DateFormatter()
        let lang = AppSettings.shared.resolvedLanguage
        switch lang {
        case .en: formatter.locale = Locale(identifier: "en_US")
        case .ja: formatter.locale = Locale(identifier: "ja_JP")
        default:  formatter.locale = Locale(identifier: "zh_CN")
        }
        return formatter.veryShortWeekdaySymbols
    }

    private var monthYearString: String {
        let formatter = DateFormatter()
        let lang = AppSettings.shared.resolvedLanguage
        switch lang {
        case .en: formatter.locale = Locale(identifier: "en_US")
        case .ja: formatter.locale = Locale(identifier: "ja_JP")
        default:  formatter.locale = Locale(identifier: "zh_CN")
        }
        formatter.setLocalizedDateFormatFromTemplate("MMMMyyyy")
        return formatter.string(from: displayedMonth)
    }

    private var monthDates: [Date?] {
        let comps = calendar.dateComponents([.year, .month], from: displayedMonth)
        guard let firstOfMonth = calendar.date(from: comps),
              let range = calendar.range(of: .day, in: .month, for: firstOfMonth) else { return [] }

        let firstWeekday = calendar.component(.weekday, from: firstOfMonth) - 1
        var dates: [Date?] = Array(repeating: nil, count: firstWeekday)

        for day in range {
            var dc = comps
            dc.day = day
            dates.append(calendar.date(from: dc))
        }
        while dates.count % 7 != 0 { dates.append(nil) }
        return dates
    }

    private var isDisplayingCurrentMonth: Bool {
        let now = Date()
        return calendar.component(.year, from: displayedMonth) == calendar.component(.year, from: now)
            && calendar.component(.month, from: displayedMonth) == calendar.component(.month, from: now)
    }

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text(monthYearString)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Spacer()

                if !isDisplayingCurrentMonth {
                    Button {
                        withAnimation(.snappy) { displayedMonth = Date() }
                    } label: {
                        Text(L("date.today"))
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(.quaternary, in: Capsule())
                    }
                    .buttonStyle(.plain)
                }

                Button {
                    withAnimation(.snappy) { shiftMonth(by: -1) }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .frame(width: 24, height: 24)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                Button {
                    withAnimation(.snappy) { shiftMonth(by: 1) }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .frame(width: 24, height: 24)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }

            // Weekday labels
            HStack(spacing: 0) {
                ForEach(Array(weekdaySymbols.enumerated()), id: \.offset) { _, symbol in
                    Text(symbol)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundStyle(.tertiary)
                        .frame(maxWidth: .infinity)
                }
            }

            // Day grid
            let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(Array(monthDates.enumerated()), id: \.offset) { _, date in
                    if let date {
                        dayCell(for: date)
                    } else {
                        Color.clear.frame(height: 34)
                    }
                }
            }
        }
        .padding(16)
        .background(.quaternary.opacity(0.3), in: RoundedRectangle(cornerRadius: 12))
    }

    private func dayCell(for date: Date) -> some View {
        let day = calendar.component(.day, from: date)
        let isToday = calendar.isDateInToday(date)
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        let isPast = date < calendar.startOfDay(for: Date()) && !isToday

        return Button {
            withAnimation(.snappy) { selectedDate = date }
        } label: {
            Text("\(day)")
                .font(.subheadline)
                .fontWeight(isToday || isSelected ? .bold : .regular)
                .foregroundColor(
                    isSelected ? .white :
                    isToday ? .blue :
                    isPast ? .gray : .primary
                )
                .opacity(isPast && !isSelected && !isToday ? 0.4 : 1.0)
                .frame(width: 34, height: 34)
                .background {
                    if isSelected {
                        Circle().fill(.blue)
                    } else if isToday {
                        Circle().strokeBorder(.blue, lineWidth: 1.5)
                    }
                }
        }
        .buttonStyle(.plain)
    }

    private func shiftMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth) {
            displayedMonth = newMonth
        }
    }
}

// MARK: - Flow Layout for Tags

struct TagFlowLayout: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                y += rowHeight + spacing
                x = 0
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }

        return CGSize(width: maxWidth, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let maxWidth = bounds.width
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                y += rowHeight + spacing
                x = 0
                rowHeight = 0
            }
            subview.place(
                at: CGPoint(x: bounds.minX + x, y: bounds.minY + y),
                proposal: .unspecified
            )
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

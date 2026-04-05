//
//  CategoryEditorSheet.swift
//  FinSight
//
//  Created by Никита Сторчай on 03.04.2026.
//

import SwiftUI
import SwiftData

struct CategoryEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(SettingsStore.self) private var settings

    let category: TransactionCategory?
    let suggestedSortIndex: Int

    @State private var name: String
    @State private var selectedColorHex: String
    @State private var selectedIconName: String?
    @State private var showingAllColors = false
    @State private var showingAllIcons = false

    private let colorColumns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 5)
    private let iconColumns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 5)

    init(category: TransactionCategory? = nil, suggestedSortIndex: Int = 0) {
        self.category = category
        self.suggestedSortIndex = suggestedSortIndex
        _name = State(initialValue: category?.name ?? "")
        _selectedColorHex = State(initialValue: category?.colorHex ?? TransactionCategory.suggestedColors[0])
        _selectedIconName = State(initialValue: category?.iconName)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    previewSurface
                    nameSurface
                    colorSurface
                    iconSurface
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 120)
            }
            .background(AppBackground())
            .scrollIndicators(.hidden)
            .navigationTitle(category == nil ? "New Category" : "Edit Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold))
                }
            }
            .safeAreaInset(edge: .bottom) {
                bottomBar
            }
        }
    }
}

private extension CategoryEditorSheet {
    var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isSaveEnabled: Bool {
        !trimmedName.isEmpty
    }

    var previewColor: Color {
        Color(hex: selectedColorHex) ?? settings.appAccentColor.color
    }

    var previewSurface: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 14) {
                CategoryIcon(
                    systemName: selectedIconName ?? "tag.fill",
                    color: previewColor,
                    size: 54
                )

                VStack(alignment: .leading, spacing: 4) {
                    Text(trimmedName.isEmpty ? "Category Preview" : trimmedName)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Text(category?.isSystem == true ? "Default category" : "Custom category")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 12)
            }

            Text("Keep it short, recognizable, and visually distinct in the picker.")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(surfaceBackground)
    }

    var nameSurface: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("NAME")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.secondary)
                .tracking(0.8)

            TextField("Category name", text: $name)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
        }
        .padding(20)
        .background(surfaceBackground)
    }

    var colorSurface: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(
                title: "COLOR",
                isExpanded: showingAllColors
            ) {
                withAnimation(.spring(response: 0.28, dampingFraction: 0.88)) {
                    showingAllColors.toggle()
                }
            }

            LazyVGrid(columns: colorColumns, spacing: 12) {
                ForEach(displayedColors, id: \.self) { colorHex in
                    let isSelected = selectedColorHex == colorHex
                    let color = Color(hex: colorHex) ?? .gray

                    Button {
                        withAnimation(.spring(response: 0.24, dampingFraction: 0.88)) {
                            selectedColorHex = colorHex
                        }
                    } label: {
                        Circle()
                            .fill(color)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.92), lineWidth: isSelected ? 3 : 0)
                                    .padding(4)
                            )
                            .overlay(
                                Circle()
                                    .stroke(isSelected ? color.opacity(0.35) : Color.clear, lineWidth: 2)
                                    .padding(1)
                            )
                            .frame(height: 42)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(20)
        .background(surfaceBackground)
    }

    var iconSurface: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(
                title: "ICON",
                isExpanded: showingAllIcons
            ) {
                withAnimation(.spring(response: 0.28, dampingFraction: 0.88)) {
                    showingAllIcons.toggle()
                }
            }

            LazyVGrid(columns: iconColumns, spacing: 12) {
                Button {
                    withAnimation(.spring(response: 0.24, dampingFraction: 0.88)) {
                        selectedIconName = nil
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(selectedIconName == nil ? previewColor.opacity(0.14) : Color.primary.opacity(0.04))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(
                                    selectedIconName == nil ? previewColor.opacity(0.28) : Color.primary.opacity(0.06),
                                    lineWidth: 1
                                )
                        )
                        .frame(height: 50)
                        .overlay {
                            Image(systemName: "tag.slash.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(selectedIconName == nil ? previewColor : .primary)
                        }
                }
                .buttonStyle(.plain)

                ForEach(displayedIcons, id: \.self) { iconName in
                    let isSelected = selectedIconName == iconName

                    Button {
                        withAnimation(.spring(response: 0.24, dampingFraction: 0.88)) {
                            selectedIconName = iconName
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(isSelected ? previewColor.opacity(0.14) : Color.primary.opacity(0.04))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(
                                        isSelected ? previewColor.opacity(0.28) : Color.primary.opacity(0.06),
                                        lineWidth: 1
                                    )
                            )
                            .frame(height: 50)
                            .overlay {
                                Image(systemName: iconName)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(isSelected ? previewColor : .primary)
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(20)
        .background(surfaceBackground)
    }

    var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()
                .overlay(Color.primary.opacity(0.06))

            Button {
                saveCategory()
            } label: {
                Text(category == nil ? "CREATE CATEGORY" : "SAVE CHANGES")
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(isSaveEnabled ? settings.appAccentColor.color : Color.primary.opacity(0.14))
                    )
                    .foregroundStyle(isSaveEnabled ? .white : .secondary)
            }
            .buttonStyle(.plain)
            .disabled(!isSaveEnabled)
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 8)
        }
        .background(.ultraThinMaterial)
    }

    var surfaceBackground: some View {
        RoundedRectangle(cornerRadius: 28, style: .continuous)
            .fill(Color(.systemBackground).opacity(0.9))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(Color.primary.opacity(0.06), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
    }

    var displayedColors: [String] {
        if showingAllColors {
            return TransactionCategory.suggestedColors
        }

        return Array(TransactionCategory.suggestedColors.prefix(10))
    }

    var displayedIcons: [String] {
        if showingAllIcons {
            return TransactionCategory.suggestedIcons
        }

        return Array(TransactionCategory.suggestedIcons.prefix(9))
    }

    func sectionHeader(title: String, isExpanded: Bool, action: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.secondary)
                .tracking(0.8)

            Spacer(minLength: 12)

            Button(action: action) {
                HStack(spacing: 6) {
                    Text(isExpanded ? "Show Less" : "Show All")
                        .font(.system(size: 12, weight: .semibold))

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 10, weight: .bold))
                }
                .foregroundStyle(settings.appAccentColor.color)
            }
            .buttonStyle(.plain)
        }
    }

    func saveCategory() {
        guard isSaveEnabled else { return }

        do {
            if let category {
                category.name = trimmedName
                category.colorHex = selectedColorHex
                category.iconName = selectedIconName

                for transaction in category.transactions {
                    transaction.syncSnapshotFromLinkedCategory()
                }
            } else {
                let newCategory = TransactionCategory(
                    name: trimmedName,
                    colorHex: selectedColorHex,
                    iconName: selectedIconName,
                    sortIndex: suggestedSortIndex
                )
                modelContext.insert(newCategory)
            }

            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save category: \(error)")
        }
    }
}

#Preview {
    CategoryEditorSheet(category: .makeDefault(from: .beauty, index: 1), suggestedSortIndex: 1).environment(SettingsStore())
}

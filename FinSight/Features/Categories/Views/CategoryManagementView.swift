//
//  CategoryManagementView.swift
//  FinSight
//
//  Created by Никита Сторчай on 03.04.2026.
//

import SwiftUI
import SwiftData

struct CategoryManagementView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(SettingsStore.self) private var settings
    @Environment(\.colorScheme) private var scheme

    @State private var showingCreateSheet = false
    @State private var editingCategory: TransactionCategory?
    @State private var didPrepareCategories = false
    @State private var categories: [TransactionCategory] = []

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 18) {
                SectionTitle(text: "Category Library")

                if categories.isEmpty {
                    emptyState
                } else {
                    LazyVStack(spacing: 10) {
                        ForEach(categories) { category in
                            categoryRow(category)
                                .transition(
                                    .asymmetric(
                                        insertion: .move(edge: .top).combined(with: .opacity),
                                        removal: .scale(scale: 0.92).combined(with: .opacity)
                                    )
                                )
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(AppBackground())
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingCreateSheet = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(settings.appAccentColor.color)
                }
            }
        }
        .sheet(isPresented: $showingCreateSheet, onDismiss: reloadCategories) {
            CategoryEditorSheet(suggestedSortIndex: nextSortIndex)
                .environment(settings)
        }
        .sheet(item: $editingCategory, onDismiss: reloadCategories) { category in
            CategoryEditorSheet(category: category, suggestedSortIndex: category.sortIndex)
                .environment(settings)
        }
        .task {
            guard !didPrepareCategories else { return }
            didPrepareCategories = true

            do {
                try CategoryMigrationService.prepare(using: modelContext)
            } catch {
                print("Failed to prepare categories in management view: \(error)")
            }

            reloadCategories()
        }
        .onAppear {
            reloadCategories()
        }
        .animation(.spring(response: 0.34, dampingFraction: 0.86), value: categories.map(\.id))
    }
}

private extension CategoryManagementView {
    var nextSortIndex: Int {
        (categories.map(\.sortIndex).max() ?? -1) + 1
    }

    var emptyState: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(settings.appAccentColor.color.opacity(0.14))

                    Image(systemName: "square.grid.2x2.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(settings.appAccentColor.color)
                }
                .frame(width: 48, height: 48)

                VStack(alignment: .leading, spacing: 4) {
                    Text("No categories yet")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.primary)

                    Text("Create your first category to personalize the picker and reports.")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
            }

            Button {
                showingCreateSheet = true
            } label: {
                Text("Create category")
                    .font(.system(size: 15, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(settings.appAccentColor.color)
                    )
                    .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .background(cardBackground)
    }

    func categoryRow(_ category: TransactionCategory) -> some View {
        HStack(spacing: 14) {
            CategoryIcon(category: category, size: 42)

            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)

                Text(category.isSystem ? "Default category" : "Custom category")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 12)

            Button {
                deleteCategory(category)
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.red)
                    .frame(width: 32, height: 32)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.red.opacity(0.10))
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onTapGesture {
            editingCategory = category
        }
    }
    
    var cardBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                scheme == .light
                ? AnyShapeStyle(Color.white)
                : AnyShapeStyle(.ultraThinMaterial)
            )
    }

    func deleteCategory(_ category: TransactionCategory) {
        let linkedTransactions = category.transactions
        let fallbackCategory = categories.first {
            $0.id != category.id && $0.legacyKey == Category.other.rawValue
        }

        withAnimation(.spring(response: 0.28, dampingFraction: 0.9)) {
            categories.removeAll { $0.id == category.id }

            linkedTransactions.forEach { transaction in
                transaction.assignCategory(fallbackCategory, fallback: .other)
            }

            modelContext.delete(category)
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to delete category: \(error)")
            reloadCategories()
        }
    }

    func reloadCategories() {
        let descriptor = FetchDescriptor<TransactionCategory>(
            sortBy: [SortDescriptor(\.sortIndex), SortDescriptor(\.createdAt)]
        )

        do {
            categories = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch categories: \(error)")
        }
    }
}

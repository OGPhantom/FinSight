//
//  TransactionsView.swift
//  FinSight
//
//  Created by Никита Сторчай on 05.02.2026.
//

import SwiftUI
import SwiftData

struct TransactionsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(SettingsStore.self) private var settings
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]

    @State private var showingAdd = false
    @State private var selectedTransaction: Transaction?

    @State private var showingSort = false
    @State private var sorting = TransactionSorting()

    @State private var viewModel = TransactionViewModel()

    private var sortedTransactions: [Transaction] {
        sorting.apply(to: transactions)
    }

    var body: some View {
        NavigationStack {
            Group {
                if transactions.isEmpty {
                    emptyState(
                        title: "No Transactions Yet",
                        subtitle: "Add your first expense to start building your spending journal.",
                        icon: "tray"
                    )
                } else if filteredTransactions.isEmpty {
                    emptyState(
                        title: "Nothing Found",
                        subtitle: "Try another merchant or note. Matching expenses will show up here.",
                        icon: "magnifyingglass"
                    )
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 24) {
                            if showingSort {
                                TransactionsSortView(sorting: $sorting)
                                    .transition(
                                        .asymmetric(
                                            insertion: .move(edge: .top).combined(with: .opacity),
                                            removal: .move(edge: .top).combined(with: .opacity)
                                        )
                                    )
                            }

                            ForEach(transactionSections) { section in
                                transactionSection(section)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 120)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(AppBackground())
            .navigationTitle("Transactions")
            .toolbar {
                if !transactions.isEmpty {
                    toolbar}
            }
            .sheet(isPresented: $showingAdd) {
                AddTransactionSheet()
            }
            .sheet(item: $selectedTransaction) { transaction in
                EditTransactionSheet(transaction: transaction)
            }
            .modifier(
                SearchableModifier(
                    isEnabled: !transactions.isEmpty,
                    text: $viewModel.searchQuery
                )
            )
        }
        .overlay(alignment: .bottomTrailing) {
            ActionButton(action: {
                showingAdd = true
            }, image: "plus")
        }
    }
}

private extension TransactionsView {
    var filteredTransactions: [Transaction] {
        viewModel.filteredTransactions(transactions: sortedTransactions)
    }

    var transactionSections: [TransactionSection] {
        let calendar = Calendar.current
        let groupedTransactions = Dictionary(grouping: filteredTransactions) { transaction in
            calendar.startOfDay(for: transaction.date)
        }

        return groupedTransactions
            .keys
            .sorted(by: sectionDateComparator)
            .map { date in
                TransactionSection(
                    date: date,
                    transactions: groupedTransactions[date] ?? []
                )
            }
    }

    func sectionDateComparator(_ lhs: Date, _ rhs: Date) -> Bool {
        sorting.order == .ascending ? lhs < rhs : lhs > rhs
    }

    func transactionSection(_ section: TransactionSection) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle(text: section.title)

            VStack(spacing: 0) {
                ForEach(Array(section.transactions.enumerated()), id: \.element.id) { index, transaction in
                    Button {
                        selectedTransaction = transaction
                    } label: {
                        TransactionRowView(transaction: transaction)
                    }
                    .buttonStyle(.plain)
                }
            }
            .background(CardBackground(cornerRadius: 22))
        }
    }

    func emptyState(title: String, subtitle: String, icon: String) -> some View {
        VStack(spacing: 18) {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(settings.appAccentColor.color.opacity(0.14))
                    .frame(width: 80, height: 80)

                Image(systemName: icon)
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(settings.appAccentColor.color)
            }

            VStack(spacing: 8) {
                Text(title)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private extension TransactionsView {
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                withAnimation(.spring(response: 0.36, dampingFraction: 0.86)) {
                    showingSort.toggle()
                }
            } label: {
                Image(systemName: showingSort ? "xmark" : "arrow.up.arrow.down")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(settings.appAccentColor.color)
                    .frame(width: 34, height: 34)
            }
        }
    }
}

private struct TransactionSection: Identifiable {
    let date: Date
    let transactions: [Transaction]

    var id: Date { date }

    var title: String {
        let calendar = Calendar.current

        if calendar.isDateInToday(date) {
            return "Today"
        }

        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        }

        return date.formatted(.dateTime.month(.abbreviated).day())
            .uppercased()
    }
}

#Preview {
    TransactionsView()
        .environment(SettingsStore())
}

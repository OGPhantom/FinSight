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
            ZStack {
                AppBackground()

                if transactions.isEmpty {
                    emptyState(
                        title: "No Transactions",
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
                                TransactionsSortHeader(sorting: $sorting)
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
            .navigationTitle("Transactions")
            .toolbar { toolbar }
            .sheet(isPresented: $showingAdd) {
                AddTransactionSheet()
            }
            .sheet(item: $selectedTransaction) { transaction in
                EditTransactionSheet(transaction: transaction)
            }
            .searchable(
                text: $viewModel.searchQuery,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: "Search expenses"
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
                    .buttonStyle(TransactionCardButtonStyle())
                    .contextMenu {
                        Button {
                            selectedTransaction = transaction
                        } label: {
                            Label("Edit", systemImage: "square.and.pencil")
                        }

                        Button(role: .destructive) {
                            deleteTransaction(transaction)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(.vertical, 6)
            .background(CardBackground(cornerRadius: 22))
        }
    }

    func emptyState(title: String, subtitle: String, icon: String) -> some View {
        VStack(spacing: 18) {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(settings.appAccentColor.color.opacity(0.14))
                    .frame(width: 74, height: 74)

                Image(systemName: icon)
                    .font(.system(size: 28, weight: .semibold))
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

    func loadTransactionsMocks() {
        let transactions = Transaction.mocks

        for transaction in transactions {
            modelContext.insert(transaction)
        }
    }

    func deleteTransaction(_ transaction: Transaction) {
        withAnimation(.spring(response: 0.28, dampingFraction: 0.9)) {
            modelContext.delete(transaction)
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to delete transaction: \(error)")
        }
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

private struct TransactionCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.992 : 1)
            .brightness(configuration.isPressed ? -0.015 : 0)
            .animation(.easeOut(duration: 0.18), value: configuration.isPressed)
    }
}

#Preview {
    TransactionsView()
        .environment(SettingsStore())
}

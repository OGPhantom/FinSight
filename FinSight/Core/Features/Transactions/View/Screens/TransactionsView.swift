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
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]

    @State private var showingAdd = false
    @State private var selectedTransaction: Transaction?

    @State private var showingSort = false
    @State private var sorting = TransactionSorting()
    var sortedTransactions: [Transaction] {
        sorting.apply(to: transactions)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                Group {
                    if transactions.isEmpty {
                        emptyState
                    } else {
                        transactionsList
                    }
                }
                .navigationTitle("Transactions")
                .toolbar { toolbar }
                .sheet(isPresented: $showingAdd, content: {
                    AddTransactionSheet()
                })
                .sheet(item: $selectedTransaction) { transaction in
                    EditTransactionSheet(transaction: transaction)
                }
//                                 .onAppear {
//                                    loadTransactionsMocks()
//                                 }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            ActionButton(action: {
                showingAdd = true
            }, image: "plus")
        }
    }
}

private extension TransactionsView {
    func loadTransactionsMocks() {
        let transactions = Transaction.mocks
        for transaction in transactions {
            modelContext.insert(transaction)
        }
    }

    func deleteTransaction(at offsets: IndexSet) {
        for index in offsets {
            let transaction = transactions[index]
            modelContext.delete(transaction)
        }
    }
}

private extension TransactionsView {
    var toolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
                     .font(.system(size: 18, weight: .semibold))
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        showingSort.toggle()
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 14, weight: .semibold))
                }
            }
        }
    }

    var emptyState: some View {
        ContentUnavailableView("No Transactions", systemImage: "tray", description: Text("Add your first transaction to get started"))
            .padding()
    }

    var transactionsList: some View {
        List {
            if showingSort {
                TransactionsSortHeader(sorting: $sorting)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }

            ForEach(sortedTransactions) { transaction in
                TransactionRowView(transaction: transaction)
                    .onTapGesture {
                        selectedTransaction = transaction
                    }
            }
            .onDelete(perform: deleteTransaction)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    TransactionsView()
}

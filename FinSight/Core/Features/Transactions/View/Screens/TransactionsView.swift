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
    @Query(
        FetchDescriptor<Transaction> (
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
    ) private var transactions: [Transaction]

    @State private var showingAdd = false
    @State private var editMode: EditMode = .inactive
    @State private var selectedTransaction: Transaction?

    @State private var showingSort = false
    @State private var sorting = TransactionSorting()

    var sortedTransactions: [Transaction] {
        sorting.apply(to: transactions)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                Group {
                    if transactions.isEmpty {
                        ContentUnavailableView("No Transactions", systemImage: "tray", description: Text("Add your first transaction to get started"))
                            .padding()
                    } else {
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
                        .background(Color.clear)
                    }
                }
                .navigationTitle("Transactions")
                .sheet(isPresented: $showingAdd, content: {
                    AddTransactionSheet()
                })
                .sheet(item: $selectedTransaction) { transaction in
                    EditTransactionSheet(transaction: transaction)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        EditToolbarButton(editMode: $editMode)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        SortToolbarButton {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                showingSort.toggle()
                            }
                        }
                    }
                }
                .environment(\.editMode, $editMode)
                // .onAppear {
                //    loadMocks()
                // }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            AddActionButton {
                showingAdd = true
            }
            .padding(.trailing, 20)
            .padding(.bottom, 20)
        }
    }
}

private extension TransactionsView {
    func loadMocks() {
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

#Preview {
    TransactionsView()
}

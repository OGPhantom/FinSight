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
                            ForEach(transactions) { transaction in
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
                        AddToolbarButton {
                            showingAdd = true
                        }
                    }
                }
                .environment(\.editMode, $editMode)
//                .onAppear { 
//                    loadMocks()
//                }
            }
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

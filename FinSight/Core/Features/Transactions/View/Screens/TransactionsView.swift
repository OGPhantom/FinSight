//
//  TransactionsView.swift
//  FinSight
//
//  Created by Никита Сторчай on 05.02.2026.
//

import SwiftUI

struct TransactionsView: View {
    @State private var transactions: [Transaction] = []
    @State private var showingAdd = false
    @State private var editMode: EditMode = .inactive

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
                .onAppear {
                    loadMocks()
                }
            }
        }
    }
}


private extension TransactionsView {
    func loadMocks() {
        self.transactions = Transaction.mocks
    }

    func deleteTransaction(at offsets: IndexSet) {
        for index in offsets {
            transactions.remove(at: index)
        }
    }
}

#Preview {
    TransactionsView()
}

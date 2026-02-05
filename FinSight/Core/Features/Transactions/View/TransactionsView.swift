//
//  TransactionsView.swift
//  FinSight
//
//  Created by Никита Сторчай on 05.02.2026.
//

import SwiftUI

struct TransactionsView: View {
    @State private var transactions: [Transaction] = Transaction.mocks
    @State private var showingAdd = false
    var body: some View {
        NavigationStack {
            Group {
                if transactions.isEmpty {
                    ContentUnavailableView("No Transactions", systemImage: "tray", description: Text("Add your first transaction to get started"))
                        .padding()
                } else {
                    List {
                        ForEach(transactions) { transaction in
                             TransactionRowView(transaction: transaction)
                        }
                    }
                }
            }
            .navigationTitle("Transactions")
            .sheet(isPresented: $showingAdd, content: {
                Text("Add Transaction here")
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    TransactionsView()
}

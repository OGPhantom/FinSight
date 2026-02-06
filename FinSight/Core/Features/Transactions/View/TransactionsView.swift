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
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                    }
                }
                .navigationTitle("Transactions")
                .sheet(isPresented: $showingAdd, content: {
                    Text("Add Transaction here")
                })
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                            .font(.system(size: 18, weight: .medium))
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingAdd = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(
                                    Circle()
                                        .fill(Color.accentColor)
                                        .shadow(
                                            color: Color.accentColor.opacity(0.4),
                                            radius: 8,
                                            x: 0,
                                            y: 4
                                        )
                                )
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TransactionsView()
}

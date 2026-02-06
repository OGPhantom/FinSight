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
    @State private var showingSort = false
    @State private var editMode: EditMode = .inactive
    @State private var selectedTransaction: Transaction?

    @State private var sort: TransactionSort = .date
    @State private var order: SortOrder = .descending

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
                            if showingSort != false {
                                withAnimation {
                                    TransactionsSortHeader(sort: $sort, order: $order)
                                }
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
                            showingSort.toggle()
                        }
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
                .environment(\.editMode, $editMode)
                //                .onAppear {
                //                    loadMocks()
                //                }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            AddToolbarButton {
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

    var sortedTransactions: [Transaction] {
        transactions.sorted {
            switch sort {
            case .date:
                order == .ascending
                ? $0.date < $1.date
                : $0.date > $1.date

            case .amount:
                order == .ascending
                ? $0.amount < $1.amount
                : $0.amount > $1.amount

            case .merchant:
                order == .ascending
                ? $0.merchant < $1.merchant
                : $0.merchant > $1.merchant
            }
        }
    }
}

enum TransactionSort: String, CaseIterable {
    case date = "Date"
    case amount = "Amount"
    case merchant = "Merchant"
}

enum SortOrder {
    case descending
    case ascending
}

struct TransactionsSortHeader: View {
    @Binding var sort: TransactionSort
    @Binding var order: SortOrder

    var body: some View {
        HStack {
            Text("Sort")

            Spacer()

            Menu {
                ForEach(TransactionSort.allCases, id: \.self) { option in
                    Button {
                        if sort == option {
                            order = order == .ascending ? .descending : .ascending
                        } else {
                            sort = option
                            order = .ascending
                        }
                    } label: {
                        Label(
                            option.rawValue,
                            systemImage: sort == option
                            ? (order == .ascending ? "arrow.up" : "arrow.down")
                            : ""
                        )
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Text(sort.rawValue)
                    Image(systemName: order == .ascending ? "arrow.up" : "arrow.down")
                }
                .font(.subheadline.weight(.semibold))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

#Preview {
    TransactionsView()
}

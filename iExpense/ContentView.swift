//
//  ContentView.swift
//  iExpense
//
//  Created by Uriel Ortega on 03/05/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false

    let localCurrency: FloatingPointFormatStyle<Double>.Currency = .currency(code: Locale.current.currency?.identifier ?? "USD")
    
    var personalExpenses: [ExpenseItem] {
        return expenses.items.filter { $0.type == "Personal" }
    }
    
    var BusinessExpenses: [ExpenseItem] {
        return expenses.items.filter { $0.type == "Business" }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Personal") {
                    List {
                        ForEach(expenses.items.filter { $0.type == "Personal" }) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.type)
                                }
                                Spacer()
                                Text(item.amount, format: localCurrency)
                                    .font(item.amount < 10 ? .title3 : (item.amount >= 10 && item.amount < 100) ? .title2 : .title)
                                    .foregroundColor(item.amount < 10 ? .mint : (item.amount >= 10 && item.amount < 100) ? .teal : .red)
                                    .bold()
                            }
                            .accessibilityElement()
                            .accessibilityLabel("\(item.name), \(item.amount, format: localCurrency)")
                            .accessibilityHint("Personal expense")
                        }
                        .onDelete(perform: removePersonalExpenses)
                    }
                }

                Section("Business") {
                    List {
                        ForEach(expenses.items.filter { $0.type == "Business" }) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.type)
                                }
                                Spacer()
                                Text(item.amount, format: localCurrency)
                                    .font(textFont(with: item.amount))
                                    .foregroundColor(textColor(with: item.amount))
                                    .bold()
                            }
                            .accessibilityElement()
                            .accessibilityLabel("\(item.name), \(item.amount, format: localCurrency)")
                            .accessibilityHint("Business expense")
                        }
                        .onDelete(perform: removeBusinessExpenses)
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removePersonalExpenses(at offsets: IndexSet) {
        // expenses.items.remove(atOffsets: offsets)
        var personalExpenses = expenses.items.filter {
            $0.type == "Personal"
        }
        personalExpenses.remove(atOffsets: offsets)
        expenses.items = personalExpenses + expenses.items.filter {
            $0.type == "Business"
        }
    }
    func removeBusinessExpenses(at offsets: IndexSet) {
        // expenses.items.remove(atOffsets: offsets)
        var businessExpenses = expenses.items.filter {
            $0.type == "Business"
        }
        businessExpenses.remove(atOffsets: offsets)
        expenses.items = businessExpenses + expenses.items.filter {
            $0.type == "Personal"
        }
    }
    
    func textFont(with amount: Double) -> Font {
        switch amount {
        case 1..<10 : return .title3
        case 10..<100 : return .title2
        default : return .title
        }
    }
    
    func textColor(with amount: Double) -> Color {
        switch amount {
        case 1..<10 : return .mint
        case 10..<100 : return .teal
        default : return .red
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

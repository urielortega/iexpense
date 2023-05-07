//
//  Expenses.swift
//  iExpense
//
//  Created by Uriel Ortega on 04/05/23.
//

import Foundation

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) { // We try encoding our items array...
                UserDefaults.standard.set(encoded, forKey: "Items") // ...and then we can write that to UserDefaults using the key “Items”.
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") { // Attempt to read the “Items” key from UserDefaults.
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) { // Create an instance of JSONDecoder.
                                                        // Ask the decoder to convert the data from UserDefaults into an array of ExpenseItem objects.
                items = decodedItems // If that worked, assign the resulting array to items...
                return // ...and exit.
            }
        }
        items = [] // Otherwise, set items to be an empty array.
    }
}

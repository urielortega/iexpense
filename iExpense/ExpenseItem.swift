//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Uriel Ortega on 04/05/23.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    
    let name: String
    let type: String
    let amount: Double
}

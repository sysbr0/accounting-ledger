//
//  TransactionModel.swift
//  16-3
//
//  Created by MUHAMMED SABIR on 16.03.2024.
//

import Foundation

struct Transaction: Identifiable {
    let id :Int
    let date :String
    let institution :String
    let account : String
    var merchant : String
    let amount : Double
    let type: TransactionType.RawValue
    var catagoryId : Int
    var Category : String
    let isPanding : Bool
    var isTransfer : Bool
    var isExpense: Bool
    var isEdited : Bool
    
    var datePaarsed : Date {
        date.dateParsed()
        
    }
    
    var singAmount: Double {
        return type == TransactionType.credit.rawValue ? amount: -amount
    }
}

enum TransactionType: String {
    case debit = "debit"
    case credit = "credit"
}

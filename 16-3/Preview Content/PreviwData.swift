//
//  PreviwData.swift
//  16-3
//
//  Created by MUHAMMED SABIR on 16.03.2024.
//

import Foundation

var transactionPreviewData = 
Transaction(id: 1, date: "01/24/2022", institution: "Desjardins", account: "Visa Desjardins", merchant: "Apple",
amount: 11.49, type: "debit", catagoryId: 801, Category: "Software", isPanding: false, isTransfer: false, isExpense: true, isEdited: false)

var transactionListPreviewData = [Transaction](repeating: transactionPreviewData, count: 10)

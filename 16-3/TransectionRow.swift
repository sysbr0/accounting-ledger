//
//  TransectionRow.swift
//  16-3
//
//  Created by MUHAMMED SABIR on 16.03.2024.
//


import SwiftUI
struct TransectionRow: View {
    var transaction : Transaction
    
    var body : some View {
        HStack(spacing: 20){
            VStack(alignment: .leading ,spacing: 6 ){
                // Marker :transaction.merchant
                Text(transaction.merchant)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(1)
                
                // Marker : Catagory info
                Text(transaction.Category)
                    .font(.footnote)
                    .opacity(0.7)
                    .lineLimit(1)
                //Marker tarnsation date
                Text(transaction.datePaarsed, format: .dateTime.year().month().day().hour().minute())
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
            }
            Spacer()
            // Marker : transaction amount
            
            Text(transaction.singAmount, format: .currency(code : "USD") )
                .bold()
                .foregroundColor(transaction.type == TransactionType.credit.rawValue
                                 ?  Color.text:  .primary )
            
        }
        .padding([.top, .bottom],8)
    }
    
}
    
#Preview {
    Group {
        TransectionRow(transaction: transactionPreviewData)
            
    }
}


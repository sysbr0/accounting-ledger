//
//  Extensions.swift
//  16-3
//
//  Created by MUHAMMED SABIR on 16.03.2024.
//

import Foundation
import SwiftUI

extension Color {
    static let Background = Color("Background")
    static let Icon = Color("Icon")
    static let Text = Color("Text")
    static let systemBackground = Color(uiColor: .systemBackground )
}

extension DateFormatter {
    static let allNumericUSA: DateFormatter = {
        print("initilizing date formatre  ")
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter
    } ()
}
extension String {
    func dateParsed() -> Date {
        guard  let parsedDate = DateFormatter.allNumericUSA.date(from: self) else {return Date()}
        
        return parsedDate
    }
}

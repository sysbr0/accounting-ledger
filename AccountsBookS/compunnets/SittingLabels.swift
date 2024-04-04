//insde component

//sitting table

//
//  sittingsLabel.swift
//  firbaseData
//
//  Created by MUHAMMED SABIR on 3.04.2024.
//

import SwiftUI

struct SettingsLabel: View {
    let imagename : String
    let title : String
    let color : Color
    
    var body: some View {
        HStack (spacing : 12 ) {
            Icons(customIcon: imagename, size: 30, color: color)
        
                .imageScale(.small)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color(.label))
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(Color(.label))
            
            
        }
    } // gear.circle.fill
}

#Preview {
    SettingsLabel(imagename: "gear.circle.fill", title: "no", color: Color(.label))
}

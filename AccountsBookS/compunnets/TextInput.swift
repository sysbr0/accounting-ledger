//compunent  text input

//
//  textInput.swift
//  firbaseData
//
//  Created by MUHAMMED SABIR on 3.04.2024.
//

import SwiftUI

struct textInput: View {
    @Binding var text :String
    let title : String
    let placeholder : String
    var isSecuredfiled = false
    
    
    var body: some View {
        VStack (alignment: .leading, spacing: 12)
        {
            Text(title)
                .foregroundColor(Color(.label))
                .fontWeight(.semibold)
                .font(.footnote)
            
            
            if isSecuredfiled {
                SecureField (placeholder ,text: $text)
                    .font(.system(size: 14))
            }
            else {
                TextField (placeholder ,text: $text)
                    .font(.system(size: 14))
            
            }
            Divider()
            
        }
    }
}

#Preview {
    textInput(text: .constant(""), title: "Email", placeholder: "your Email Adress")
}

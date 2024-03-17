//
//  ContentView.swift
//  16-3
//
//  Created by MUHAMMED SABIR on 16.03.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(alignment: .leading , spacing: 24){
                    // Mark : Title
                    Text("overview")
                        .font(.title2)
                        .bold()
                }
                .padding()
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            }
            .background(Color.background)
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
            // Marke : Notification icon
                ToolbarItem{
                    Image(systemName: "bell.badge")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.icon, .primary)
                }
                
            }
          
        }
        .navigationViewStyle(.stack)

     

    }
}

#Preview {
    
    Group {
        ContentView()
            .preferredColorScheme(.dark)
        
           
    }}
#Preview {
    
    Group {
       
      
        TransectionRow(transaction: transactionPreviewData)
       
           
    }}

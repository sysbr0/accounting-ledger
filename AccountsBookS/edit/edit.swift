
//  edit.swift
//  firbaseData1
//
//  Created by MUHAMMED SABIR on 5.04.2024.
//

import SwiftUI

struct edit: View {
    @EnvironmentObject var viewModel : AutViewNodel
    
    @State private var emailchange = ""
    @State private var password = ""

    @State private var showAlert = false

    
    
    
    var body: some View {

        
       if viewModel.currentUser != nil {
            
         
            
            List {
                Section ("Email "){
                    HStack {
                        
                    
                        SettingsLabel(imagename: "email", title: viewModel.userSession?.email ?? "not found", color: .green)
                        Spacer()
                        
                        Button {
                            showAlert.toggle()
                        }
                        label : {
                            Icons(customIcon: "edit", size: 30, color: viewModel.darkMode ? .white : .black)
                        }
                        .alert("Login", isPresented: $showAlert, actions: {
                            TextField("Email ", text: $emailchange)

                         
                    Button("conform ", action: {
                                    
                                      
              print(emailchange)
                            Task {
                                do {
                                    
                                    viewModel.changeEmail(emailchange)
                                }
                             }
                                          
                                      
                                      
                                      
                                  })
                                  Button("Cancel", role: .cancel, action: {})
                              }, message: {
                                  Text("Please enter your new email .")
                              })
                    }
                }}
        }
    }
}

#Preview {
    edit()
}

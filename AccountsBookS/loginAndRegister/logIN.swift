// authuncation — view — login

//
//  loginView.swift
//  firbaseData
//
//  Created by MUHAMMED SABIR on 3.04.2024.
//

import SwiftUI

struct loginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel : AutViewNodel
    
    var body: some View {
 
        
        
        
        NavigationStack{
            
            VStack{
              
                Image("logo")
                      
                       .resizable()
                       .scaledToFit()
                       .frame(width: 250 ,height: 100)
                      
                       .padding(.vertical ,80)
                  
            }
                VStack(spacing : 12 ){
                   textInput(text: $email,
                             title: "Email Adress",
                             placeholder: "name@doman.com")
                   .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    
                    
                    
                    textInput(text: $password,
                              title: "Password ",
                              placeholder: "your Password" ,isSecuredfiled: true) // for hiding password
                    
                    NavigationLink {
                        PasswordResetView()
                      .navigationBarBackButtonHidden(false)
                    } label: {
                        HStack {
                            Spacer()
                            Text("forget password ? ")
                                .foregroundStyle(.red)
                       
                         
                                .bold()
                       
                        }
                        .font(.system(size: 14))
                        .foregroundColor(Color(.label))
                       
                    }
                }
                .padding(.horizontal)
                .padding(.bottom ,22)
                
               
                   
            Button {
                if !email.isEmpty && !password.isEmpty && email.contains("@") {
                
                    Task{ try await // becuse we are using asybc away
                        viewModel.signIn(withEmail: email, password: password) }
                }
            } label: {
                HStack {
                    Text("SIGN IN ")
                        .fontWeight(.semibold)
                    Icons(customIcon: "next", size: 20, color: Color(.white))
                 
                    
                }
                
                .foregroundColor(Color(.white))
                .frame(width: 360 ,height: 50)
                
            }
            .background(Color(.black))
           
            .opacity(formIsValid ? 1.0 : 0.5)
            .border(Color(.label))
            .cornerRadius(8)
           
            Spacer()
            
            NavigationLink {
                singup()
              .navigationBarBackButtonHidden(true)
            } label: {
                HStack {
                    Text("Alrady  have an account ")
                    Text("Sign IN ")
                        .bold()
                }
                .font(.system(size: 14))
                .foregroundColor(Color(.label))
               
            }
        }
        
    }
}







extension  loginView  :  AuthnticationFormProtocol {

    
 
    
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        &&   email.contains(".")
        && !password.isEmpty
        && password.count > 5
    
    }
    
    
}

#Preview {
    loginView()
}

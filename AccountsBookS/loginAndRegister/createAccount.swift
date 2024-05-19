// Authcation == View == create account
//
//  singup.swift
//  firbaseData
//
//  Created by MUHAMMED SABIR on 3.04.2024.
//

import SwiftUI

struct singup: View {
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    @State private var conformpassword = ""
    @State var shouldShowImagePicker = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel : AutViewNodel
    
    
    @State private var image: UIImage?
    @State private var isImagePickerPresented = false
    @State private var uploadStatusMessage: String?
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    
                    Spacer()
                    
                    
                    
                    Button {
                        shouldShowImagePicker.toggle()
                    } label: {
                        
                        VStack {
                            if  let image = self.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 128, height: 128)
                                    .cornerRadius(64)
                            } else {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 64))
                                    .padding()
                                    .foregroundColor(Color(.label))
                            }
                        }
                        .overlay(RoundedRectangle(cornerRadius: 64)
                            .stroke(Color.black, lineWidth: 3)
                        )
                        
                        
                        
                    }
                }
                .padding(20)// end of v stack
                VStack(spacing : 12 ){
                    textInput(text: $email,
                              title: "Email Adress",
                              placeholder: "name@doman.com")
                    .autocapitalization(.none)
                    
                    textInput(text: $fullName,
                              title: "Full name ",
                              placeholder: "Your Name ")
                    
                    
                    
                    textInput(text: $password,
                              title: "Password ",
                              placeholder: "your Password" ,isSecuredfiled: true) // for hiding password
                    HStack {
                        textInput(text: $conformpassword,
                                  title: "Repeat Password ",
                                  placeholder: "Repeat  Password" ,isSecuredfiled: true) // for hiding password
                        if !password.isEmpty {
                            if password == conformpassword {
                                Icons(customIcon: "ok", size: 25, color: Color(.green))
                            } else {
                                Icons(customIcon: "close", size: 25, color: Color(.red))
                            }
                        }
                        
                    }
                }
                .padding(.horizontal)
                .padding(.bottom ,22)
                
                
                
                Button {
                    Task{
                        try await // becuse we are using asybc away
                        viewModel.createUser(withEnail : email ,password: password, fullname: fullName )
                        print ("clicked ")
                    }
                } label: {
                    HStack {
                        Text("SIGN UP ")
                            .fontWeight(.semibold)
                        Icons(customIcon: "next", size: 20, color: Color(.label))
                        
                        
                    }
                    
                    .foregroundColor(Color(.white))
                    .frame(width: 360 ,height: 50)
                }
                .background(Color(.black))
                
                .opacity(formIsVaied ? 1.0 : 0.5)
                .border(Color(.label))
                .cornerRadius(8)
                
                Spacer()
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Text(" Dont have an account ")
                        Text("Sign UP")
                            .bold()
                    }
                    .font(.system(size: 14))
                    .foregroundColor(Color(.label))
                }
                
                .navigationViewStyle(StackNavigationViewStyle())
                .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                    ImagePicker(image: $image)
                }}
        }// scroll view
        } // navigation view end
    } //boody end
extension  singup  :  AuthnticationFormProtocol {
    var formIsVaied: Bool {
        return !email.isEmpty
        && email.contains("@")
        &&   email.contains(".")
        && !password.isEmpty
        && password.count > 5
        && !fullName.isEmpty
        &&  conformpassword == password
    
    }
    
    
}
#Preview {
    singup()
}



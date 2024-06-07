import SwiftUI

struct singup: View {
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    @State private var conformpassword = ""
    @State private var image: UIImage?
    @State var shouldShowImagePicker = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel : AutViewNodel
    
    @State private var isImagePickerPresented = false
    @State private var uploadStatusMessage: String?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Spacer()
                    
                    Button {
                        shouldShowImagePicker.toggle()
                    } label: {
                        VStack {
                            if let image = self.image {
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
                .padding(20)
                
                VStack(spacing: 12) {
                    textInput(text: $email, title: "Email Address", placeholder: "name@domain.com")
                        .autocapitalization(.none)
                    
                    textInput(text: $fullName, title: "Full Name", placeholder: "Your Name")
                    
                    textInput(text: $password, title: "Password", placeholder: "Your Password", isSecuredfiled: true)
                    
                    HStack {
                        textInput(text: $conformpassword, title: "Repeat Password", placeholder: "Repeat Password", isSecuredfiled: true)
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
                .padding(.bottom, 22)
                
                Button {
                    signUp()
                } label: {
                    HStack {
                        Text("SIGN UP")
                            .fontWeight(.semibold)
                        Icons(customIcon: "next", size: 20, color: Color(.label))
                    }
                    .foregroundColor(Color(.white))
                    .frame(width: 360, height: 50)
                }
                .background(Color(.black))
                .opacity(formIsValid ? 1.0 : 0.5)
                .border(Color(.label))
                .cornerRadius(8)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Text("Already have an account?")
                        Text("Log In")
                            .bold()
                    }
                    .font(.system(size: 14))
                    .foregroundColor(Color(.label))
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                ImagePicker(image: $image)
            }
        }
    }
    
    private func signUp() {
        Task {
            do {
                try await authViewModel.createUser(withEmail: email, password: password, fullName: fullName, image: image) { success in
                    if success {
                        print("User successfully signed up")
                    } else {
                        print("Sign up failed")
                    }
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

extension singup: AuthnticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
            && email.contains("@")
            && email.contains(".")
            && !password.isEmpty
            && password.count > 5
            && !fullName.isEmpty
            && conformpassword == password
    }
}


import SwiftUI
struct SignUpView: View {
    @State private var email = "" // done
    @State private var password = "" //done
    @State private var fullName = "" //done
    @State private var confirmPassword = "" //done
    @State private var image: UIImage? //done
    @State private var shouldShowImagePicker = false //done
    
    @EnvironmentObject var authViewModel: AutViewNodel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Full Name", text: $fullName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    shouldShowImagePicker.toggle()
                }) {
                    Text("Select Profile Image")
                }
                
                if let selectedImage = image {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                }
                
                Button(action: {
                    signUp()
                }) {
                    Text("Sign Up")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .sheet(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $image)
        }
    }
    
    private func signUp() {
        Task {
            do {
                try await authViewModel.createUser(withEmail: email, password: password, fullName: fullName, image: image) { success in
                    if success {
                        // Handle successful sign up
                    } else {
                        // Handle sign up failure
                    }
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

import SwiftUI

struct UserInfo: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    @EnvironmentObject var viewModel: AutViewNodel
    @State private var showAlert = false
    @State private var userProfileImage: UIImage?
    
    var body: some View {
        NavigationView {
        
            if let user = viewModel.currentUser {
              
                List {
                    VStack{
                        
                    }
                    Section {
                       
                        HStack {
                            
                            if let image = userProfileImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 72, height: 72)
                                    .background(Color(.systemGray3))
                                    .cornerRadius(36)
                            } else {
                                Text(user.intials)
                                    .font(.title)
                                    .foregroundColor(viewModel.darkMode ? .white : .black)
                                    .frame(width: 72, height: 72)
                                    .background(Color(.systemGray3))
                                    .cornerRadius(36)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullname)
                                    .font(.footnote)
                                    .bold()
                                    .padding(.top, 4)
                                Text(user.email)
                                    .font(.footnote)
                                    .accentColor(viewModel.darkMode ? .white : .black)
                            }
                            .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            NavigationLink(destination: edit()) {
                                HStack {
                                    Spacer()
                                    Icons(customIcon: "edit", size: 30, color: Color(.label))
                                }
                            }
                        }
                    }
                    
                    Section("General") {
                        HStack(spacing: 189) {
                            SettingsLabel(imagename: "gear", title: "Version", color: Color(.label))
                            Text(appVersion)
                        }
                        
                        HStack {
                            SettingsLabel(imagename: "dark", title: "Dark Mode", color: Color(.label))
                            Toggle(isOn: $viewModel.darkMode) {
                                // Empty closure for toggle
                            }
                        }
                    }
                    
                    Section("Account") {
                        Button {
                            showAlert.toggle()
                        } label: {
                            SettingsLabel(imagename: "power", title: "Log Out", color: Color(.red))
                        }
                        .alert("Are you sure?",
                               isPresented: $showAlert,
                               actions: {
                            Button("No", role: .cancel) {}
                            Button("Yes", role: .destructive) {
                                viewModel.signOut()
                            }
                        }, message: {
                            Text("You are going to log out!")
                        })
                        
                        Button {
                            showAlert.toggle()
                        } label: {
                            SettingsLabel(imagename: "trash.fill", title: "Remove Account", color: Color(.red))
                        }
                        .alert("Are you sure?",
                               isPresented: $showAlert,
                               actions: {
                            Button("No", role: .cancel) {}
                            Button("Yes", role: .destructive) {
                                viewModel.deleteAccount()
                            }
                        }, message: {
                            Text("You are going to remove your account!")
                        })
                    }
                }
                .onAppear {
                    fetchUserProfileImage()
                }
                .preferredColorScheme(viewModel.darkMode ? .dark : .light)
                .ignoresSafeArea()
            } else {
                Text("Please reopen the application")
            }
        }
    }
    
    private func fetchUserProfileImage() {
        viewModel.fetchUserProfileImageURL { url in
            guard let imageURL = url else { return }
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                guard let data = data, error == nil else {
                    print("Failed to fetch profile image: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                DispatchQueue.main.async {
                    self.userProfileImage = UIImage(data: data)
                }
            }.resume()
        }
    }
}

struct UserInfo_Previews: PreviewProvider {
    static var previews: some View {
        UserInfo()
            .environmentObject(AutViewNodel())
    }
}

import SwiftUI

struct UserInfo1: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    @EnvironmentObject var viewModel: AutViewNodel
    @State private var showAlert = false
    @State private var userProfileImage: UIImage? // Add state variable to hold the profile image
    
    var body: some View {
        NavigationView {
            if let user = viewModel.currentUser {
                List {
                    Section {
                        HStack {
                            if let image = userProfileImage { // Display profile image if available
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
                            
                            //done
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullname)
                                    .font(.title3)
                                    .bold()
                                    .padding(.top, 4)
                                Text(user.email)
                                    .font(.footnote)
                                    .accentColor(viewModel.darkMode ? .white : .black)
                            }
                            .multilineTextAlignment(.leading)
                            
                            Spacer()
                            //done
                            
                            NavigationLink(destination: edit()) {
                                HStack {
                                    Spacer()
                                    
                                    Icons(customIcon: "edit", size: 30, color: Color(.label))
                                }
                            }
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("Profile")
                        }
                    }
                    //
                    
                    // Remaining sections...
                }
                .onAppear {
                    fetchUserProfileImage()
                }
            }
        }
        .preferredColorScheme(viewModel.darkMode ? .dark : .light)
        .ignoresSafeArea()
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

struct UserInfo1_Previews: PreviewProvider {
    static var previews: some View {
        UserInfo1().environmentObject(AutViewNodel())
    }
}

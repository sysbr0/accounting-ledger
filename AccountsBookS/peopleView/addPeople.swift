
import SwiftUI

struct UserView: View {
    @StateObject var authViewModel = AutViewNodel()
    @State private var userEmail: String = ""
    @State private var userData: [String: Any]?


    var body: some View {
        VStack {
            HStack {
                textInput(text: $userEmail, title: "serch by email", placeholder: "Enter user's email")
              
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: {
                    fetchUserId()
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.blue)
                        .padding(.horizontal)
                }
            }
            .padding(.top)
            
            Divider() // This adds a line under the search bar
            
       
            
            if let userData = userData {
                HStack {
                    if let imageURLString = userData["profileImgeURL"] as? String,
                       let imageURL = URL(string: imageURLString) {
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60) // Adjust size as needed
                                .border(.green)
                                .clipShape(Circle())
                               
                        } placeholder: {
                            // Placeholder while loading
                            ProgressView()
                        }
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 90, height: 90)
                            .foregroundColor(.gray)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Name: \(userData["fullname"] as? String ?? "N/A")")
                            .font(.headline)
                        Text("Email: \(userData["email"] as? String ?? "N/A")")
                            .font(.subheadline)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Button(action: { // save the user id
                        if let userId = userData["id"] as? String ,let name = userData["fullname"] as? String , let mail = userData["email"] as? String, let img = userData["profileImgeURL"] as? String {
                            authViewModel.saveUserIdToContactList(userId: userId, name: name, email : mail , img: img ) { result in
                                               switch result {
                                               case .success:
                                                   print("User ID saved to ContactList")
                                               case .failure(let error):
                                                   print("Error saving user ID: \(error.localizedDescription)")
                                               }
                                           }
                                       }
                                   })
                    {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title)
                    }
                }
                .padding()
            } else {
                Text("No user data fetched")
            }
            
            Spacer()
        }
        .padding()
        .foregroundColor(.primary)
        .containerShape(.capsule)

    }
    
    private func fetchUserId() {
        authViewModel.fetchUserIdByEmail(email: userEmail) { result in
            switch result {
            case .success(let userId):
                fetchUserData(userId: userId)
            case .failure(let error):
                print(error.localizedDescription)
                self.userData = nil
            }
        }
    }
    
    private func fetchUserData(userId: String) {
        authViewModel.fetchUserDataByUserId(userId: userId) { result in
            switch result {
            case .success(let data):
                self.userData = data
            case .failure(let error):
                print(error.localizedDescription)
                self.userData = nil
            }
        }
    }
}

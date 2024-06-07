import SwiftUI

struct ContactListView: View {
    @ObservedObject var authViewModel: AutViewNodel
    
    var body: some View {
        NavigationView {
            List {
                ForEach($authViewModel.contactList) { $contact in
                    NavigationLink(destination: ChatView(contact: contact)) {
                        HStack {
                            if let imageURL = contact.imageURL {
                                AsyncImage(url: imageURL) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView() // Placeholder for when image is loading
                                    case .success(let image):
                                        image
                                            .resizable() // Apply resizable directly to the image view
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                    case .failure:
                                        Image(systemName: "exclamationmark.triangle") // Placeholder for when image loading fails
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(.red)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            } else {
                                Image(systemName: "person.circle") // Placeholder for when no image URL is available
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            }
                            VStack(alignment: .leading) {
                                Text("Name: \(contact.name)")
                                Text("Email: \(contact.email)")
                                
                                Text("Balance: \(String(format: "%.2f", contact.balance))")
                                    .foregroundColor(contact.balance > 0 ? .green : .red)
                                // Add any other fields you want to display
                            }
                        }
                    }
                }
            }
            .onAppear {
                authViewModel.fetchContactList { result in
                    switch result {
                    case .success(let contacts):
                        authViewModel.contactList = contacts
                        print("Contact list fetched successfully")
                    case .failure(let error):
                        print("Error fetching contact list: \(error.localizedDescription)")
                    }
                }
            }
            .navigationBarTitle("Contacts")
        }
    }
}

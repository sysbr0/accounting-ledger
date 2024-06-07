import SwiftUI
struct MessagesListView: View {
    @State private var contacts: [MyContacts] = [
        // Sample data
        MyContacts(id: "1", name: "John Doe", email: "john@example.com", imageURL: URL(string: "https://example.com/john.jpg")!),
        MyContacts(id: "2", name: "Jane Smith", email: "jane@example.com", imageURL: URL(string: "https://example.com/jane.jpg")!)
    ]

    var body: some View {
        NavigationView {
            List(contacts, id: \.id) { contact in
                NavigationLink(destination: ChatView(contact: contact)) {
                    HStack {
                        AsyncImage(url: contact.imageURL) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                        VStack(alignment: .leading) {
                            Text(contact.name)
                                .font(.headline)
                            Text(contact.email)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Messages")
        }
    }
}

struct MessagesListView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesListView()
    }
}

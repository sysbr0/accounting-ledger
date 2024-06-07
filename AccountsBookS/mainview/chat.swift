import SwiftUI
import FirebaseFirestore

struct ChatView: View {
    let contact: MyContacts
    @EnvironmentObject var authViewModel: AutViewNodel

    @State private var messages: [ChatMessage] = []
    @State private var newMessage: String = ""
    @State private var newNumber: String = ""

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(messages) { message in
                        HStack {
                            if message.senderId == authViewModel.currentUser?.id {
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(message.text)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                        .padding(.vertical, 2)
                                    if let amount = message.amount {
                                        Text("Amount: \(amount)")
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                    }
                                }
                            } else {
                                VStack(alignment: .leading) {
                                    Text(message.text)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                        .padding(.vertical, 2)
                                    if let amount = message.amount {
                                        Text("Amount: \(amount)")
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }

            HStack {
                TextField("Enter your message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Enter a number", text: $newNumber)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        // Add custom back action if needed
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                    }

                    AsyncImage(url: contact.imageURL) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                    }

                    VStack(alignment: .leading) {
                        Text(contact.email)
                            .font(.headline)
                    }
                    .padding(.leading, 8)
                }
            }
        }
        .onAppear {
            fetchMessages()
        }
    }

    func sendMessage() {
        guard !newMessage.isEmpty else { return }
        let amount = Float(newNumber)

        authViewModel.sendMessage(to: contact.id, text: newMessage, amount: amount) { result in
            switch result {
            case .success():
                fetchMessages() // Refresh messages after sending a new one
                newMessage = ""
                newNumber = ""
            case .failure(let error):
                print("Error sending message: \(error.localizedDescription)")
            }
        }
    }

    func fetchMessages() {
        authViewModel.fetchMessages(with: contact.id) { result in
            switch result {
            case .success(let messages):
                self.messages = messages.sorted { $0.timestamp.dateValue() < $1.timestamp.dateValue() }
            case .failure(let error):
                print("Error fetching messages: \(error.localizedDescription)")
            }
        }
    }
}

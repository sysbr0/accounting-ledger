
import FirebaseFirestore

struct Contact: Identifiable {
    let id: String
    let userId: String
    let dateAdded: Timestamp
}



struct ChatMessage: Identifiable {
    let id: String
    let senderId: String
    let receiverId: String
    let text: String
    let timestamp: Timestamp
    let amount: Float?
}

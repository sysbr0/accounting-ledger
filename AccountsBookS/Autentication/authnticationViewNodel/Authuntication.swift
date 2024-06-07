// Authocation — Author model view

//
//  authVeiwModel.swift
//  firbaseData
//
//  Created by MUHAMMED SABIR on 3.04.2024.
/*

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage



protocol AuthnticationFormProtocol {
    var formIsVaied: Bool {get}
}
@MainActor
class AutViewNodel : ObservableObject {
    
    
    @Published var errorMessage: String = "" // for displying messge
   
    @Published var userSession : FirebaseAuth.User?
    @Published var curentuser : User? // from model/user
    @Published var showAlert = false
    @Published var loginStatusMessage = ""
    @Published var darkmode = false {
          didSet {                UserDefaults.standard.set(darkmode, forKey: "darkmode")
          }
      }
    let auth: Auth
    let storage: Storage
    
    init() {
        self.userSession =  Auth.auth().currentUser
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        
        Task{
            await fatchUser()
            print(curentuser?.email ?? " no user  ")
        }
    }
    
    
    
    
    
    func signIn(withEmail email :String  , password : String) async  throws  {
        
     
        do {
            print(email)
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            
           // await fatchUser()
        }
        catch{
            print(error.localizedDescription)
            
        }
    }
    
    func createUser(withEmail email: String, password: String, fullName: String, image: UIImage?, completion: @escaping (Bool) -> Void) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            var profileImageURL: URL?
            if let image = image {
                let userID = result.user.uid
                profileImageURL = try await uploadProfileImage(image, userID: userID)
            }
            
            let user = User(id: result.user.uid, fullname: fullName, email: email, profileImgeURL: profileImageURL ?? URL(string : "https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png")!)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser) // get informatiom
            
            await fatchUser()
            completion(true)
        } catch {
            print("Could not create user with error: \(error.localizedDescription)")
            completion(false)
        }
    }

    func uploadProfileImage(_ image: UIImage, userID: String) async throws -> URL? {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Failed to convert image to data")
            return nil
        }

        let imageName = "\(userID).jpg"
        let storageRef = Storage.storage().reference().child("profile_images").child(imageName)
        let uploadTask = storageRef.putData(imageData, metadata: nil)

        return try await withCheckedThrowingContinuation { continuation in
            uploadTask.observe(.success) { snapshot in
                storageRef.downloadURL { url, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let downloadURL = url {
                        continuation.resume(returning: downloadURL)
                    } else {
                        continuation.resume(throwing: NSError(domain: "UploadTask", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"]))
                    }
                }
            }
            uploadTask.observe(.failure) { error in
                continuation.resume(throwing: error as! Error)
            }
        }
    }


    
    
    
    func signout(){
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.curentuser = nil
        }
        catch {
            print(" faild to log out")
        }
    }
    

    func fatchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else  {return}
        
        guard  let snapshot =  try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.curentuser =  try?  snapshot.data(as: User.self)
        
   
 
    }
    
    
    
    func changeEmail(_ newEmail: String) {
        let auth = Auth.auth()
        auth.currentUser?.updateEmail(to: newEmail) { error in
          
           
        }
    } // change email


    func darkmodefunc() {
        self.darkmode = true
        
    } // dark mode
    
    func showdetiles() {
        print(self.curentuser?.fullname ?? "nothing ")
    } // show worning
    
    func DeleteAccount() {
            do {
                guard let user = Auth.auth().currentUser else {
                    print("No user is currently signed in.")
                    return}
              
                
                user.delete { error in
                    if error != nil {
                    // An error happened.
                  } else {
               print("eccountdeleted")
                  }
                }
                self.userSession = nil
                self.curentuser = nil
                
            } // delete account
            
           
            
            
       

        }
    func ForgetPassword(withEmail email :String ) async  throws {
        print(email)
        
    }
    
    
    
    
    func resetPassword(email: String) {
            let db = Firestore.firestore()
            
            db.collection("users")
                .whereField("email", isEqualTo: email)
                .getDocuments { [weak self] (querySnapshot, error) in
                    guard let self = self else { return }
                    if let error = error {
                        // chek errop
                        self.errorMessage = error.localizedDescription
                        self.showAlert = true
                    } else if let documents = querySnapshot?.documents {
                        if documents.isEmpty {
                           
                            self.errorMessage = "Email not found"
                            self.showAlert = true
                        } else {
                           
                            Auth.auth().sendPasswordReset(withEmail: email) { error in
                                if let error = error {
                                   
                                    self.errorMessage = error.localizedDescription
                                    self.showAlert = true
                                } else {
                                   /// send reset passwoeeed to the email
                                    print("Password reset email sent successfully")
                                    self.showAlert = true
                                    self.errorMessage = "Password reset email sent successfully"
                                }
                            }
                        }
                    }
                }
        }
    
    func persistImageToStorage(image: UIImage?, completion: @escaping (Bool) -> Void) {
            guard let uid = self.auth.currentUser?.uid else {
                completion(false)
                return
            }
            let ref = storage.reference(withPath: uid)
            guard let imageData = image?.jpegData(compressionQuality: 0.5) else {
                completion(false)
                return
            }
            ref.putData(imageData, metadata: nil) { metadata, err in
                if let err = err {
                    self.loginStatusMessage = "Failed to push image to Storage: \(err)"
                    completion(false)
                    return
                }
                ref.downloadURL { url, err in
                    if let err = err {
                        self.loginStatusMessage = "Failed to retrieve download URL: \(err)"
                        completion(false)
                        return
                    }
                    self.loginStatusMessage = "Successfully stored image with URL: \(url?.absoluteString ?? "")"
                    completion(true)
                }
            }
        }
        
        func fetchUserProfileImageURL(completion: @escaping (URL?) -> Void) {
            guard let uid = auth.currentUser?.uid else {
                completion(nil)
                return
            }
            let ref = storage.reference(withPath: uid)
            ref.downloadURL { url, error in
                if let error = error {
                    print("Failed to retrieve download URL: \(error)")
                    completion(nil)
                    return
                }
                completion(url)
            }
        }
    
    
    
    
    func fetchUserProfileImageURL(completion: @escaping (URL?) -> Void) {
            guard let uid = auth.currentUser?.uid else {
                completion(nil)
                return
            }
            let ref = storage.reference(withPath: uid)
            ref.downloadURL { url, error in
                if let error = error {
                    print("Failed to retrieve download URL: \(error)")
                    completion(nil)
                    return
                }
                completion(url)
            }
        }

    func fetchUserNameAndEmail(completion: @escaping (String?, String?) -> Void) {
        guard let uid = auth.currentUser?.uid else {
            completion(nil, nil)
            return
        }
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            guard let snapshot = snapshot, snapshot.exists else {
                completion(nil, nil)
                return
            }
            let data = snapshot.data()
            let name = data?["fullname"] as? String
            let email = data?["email"] as? String
            completion(name, email)
        }
    }

    
    
}

*/


import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage
import SwiftUI
import Combine
protocol AuthnticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AutViewNodel: ObservableObject {
    @Published var errorMessage: String = "" // for displaying messages
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User? // from model/user
    @Published var showAlert = false
    @Published var loginStatusMessage = ""
    @Published var contactList: [MyContacts] = []
    @Published var contacts: [Contact] = []
    @Published var messages: [ChatMessage] = []
    @Published var myContacts: [String: MyContacts] = [:] // Store user data using user ID as key
    // Store user data using user ID as key
    @Published var totalReceived: Float = 0.0
    @Published var totalSent: Float = 0.0
    @Published var Total: Float = 0.0
    

    @Published var darkMode = false {
        didSet {
            UserDefaults.standard.set(darkMode, forKey: "darkmode")
        }
    }
    let auth: Auth
    let storage: Storage
    
    init() {
        self.userSession = Auth.auth().currentUser
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        
        Task {
            await fetchUser()
            print(currentUser?.email ?? "No user")
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createUser(withEmail email: String, password: String, fullName: String, image: UIImage?, completion: @escaping (Bool) -> Void) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            var profileImageURL: URL?
            if let image = image {
                profileImageURL = try await uploadProfileImage(image, userId: result.user.uid)
            }
            
            let user = User(id: result.user.uid, fullname: fullName, email: email, profileImgeURL: profileImageURL ?? URL(string: "https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png")!)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser) // get information
            
            await fetchUser()
            completion(true)
        } catch {
            print("Could not create user with error: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("Failed to log out")
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
    func changeEmail(_ newEmail: String) {
        let auth = Auth.auth()
        auth.currentUser?.updateEmail(to: newEmail) { error in
            // handle error
        }
    }
    
    func darkModeFunc() {
        self.darkMode = true
    }
    
    func showDetails() {
        print(self.currentUser?.fullname ?? "Nothing")
    }
    
    func deleteAccount() {
        do {
            guard let user = Auth.auth().currentUser else {
                print("No user is currently signed in.")
                return
            }
            
            user.delete { error in
                if error != nil {
                    // An error happened.
                } else {
                    print("Account deleted")
                }
            }
            self.userSession = nil
            self.currentUser = nil
        }
    }
    
    func forgetPassword(withEmail email: String) async throws {
        print(email)
    }
    
    func resetPassword(email: String) {
        let db = Firestore.firestore()
        
        db.collection("users")
            .whereField("email", isEqualTo: email)
            .getDocuments { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                } else if let documents = querySnapshot?.documents, !documents.isEmpty {
                    Auth.auth().sendPasswordReset(withEmail: email) { error in
                        if let error = error {
                            self.errorMessage = error.localizedDescription
                            self.showAlert = true
                        } else {
                            self.errorMessage = "Password reset email sent successfully"
                            self.showAlert = true
                        }
                    }
                } else {
                    self.errorMessage = "Email not found"
                    self.showAlert = true
                }
            }
    }
    
    func uploadProfileImage(_ image: UIImage, userId: String) async throws -> URL? {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Failed to convert image to data")
            return nil
        }
        
        let storageRef = Storage.storage().reference().child("profile_images").child("\(userId).jpg")
        let uploadTask = storageRef.putData(imageData, metadata: nil)
        
        return try await withCheckedThrowingContinuation { continuation in
            uploadTask.observe(.success) { _ in
                storageRef.downloadURL { url, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let downloadURL = url {
                        continuation.resume(returning: downloadURL)
                    } else {
                        continuation.resume(throwing: NSError(domain: "UploadTask", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"]))
                    }
                }
            }
            uploadTask.observe(.failure) { error in
                continuation.resume(throwing: error as! any Error)
            }
        }
    }
    
    func fetchUserProfileImageURL(completion: @escaping (URL?) -> Void) {
        guard let uid = auth.currentUser?.uid else {
            completion(nil)
            return
        }
        let ref = storage.reference(withPath: "profile_images/\(uid).jpg")
        ref.downloadURL { url, error in
            if let error = error {
                print("Failed to retrieve download URL: \(error)")
                completion(nil)
            } else {
                completion(url)
            }
        }
        
        
        
        
        
    }
    
    
    // Function to fetch user ID by email
    func fetchUserIdByEmail(email: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Query Firestore to get user ID by email
        let db = Firestore.firestore()
        db.collection("users")
            .whereField("email", isEqualTo: email)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "No user found with that email."])))
                    return
                }
                
                guard let userId = document.data()["id"] as? String else {
                    completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "User ID not found in document."])))
                    return
                }
                
                // Successfully found the user ID, now return it
                completion(.success(userId))
            }
    }
    func fetchUserDataByUserId(userId: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // Reference to the user's document in the "users" collection
        let userDocRef = Firestore.firestore().collection("users").document(userId)
        
        // Get the document snapshot for the user's document
        userDocRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let userData = document?.data() else {
                completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "No user data found with that user ID."])))
                return
            }
            
            // Successfully found the user data, now return it
            completion(.success(userData))
        }
    }
    // save the user id
    func saveUserIdToContactList(userId: String, name: String, email: String, img: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUserId = currentUser?.id else {
            completion(.failure(NSError(domain: "", code: 403, userInfo: [NSLocalizedDescriptionKey: "User not authenticated."])))
            return
        }

        let db = Firestore.firestore()
        let contactListRef = db.collection("ContactList").document(userId)

        // Check if the userId is not equal to currentUserId
        if userId != currentUserId {
            contactListRef.getDocument { document, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                if let document = document, document.exists {
                    // Check if the current user already added this userId
                    if let existingSid = document.data()?["sid"] as? String, existingSid == currentUserId {
                        // User already exists and was added by the current user, do nothing
                        completion(.success(()))
                    } else {
                        // User exists but was not added by the current user, update the document
                        contactListRef.updateData([
                            "userId": userId,
                            "dateAdded": Timestamp(date: Date()),
                            "name": name,
                            "email": email,
                            "img": img,
                            "sid": currentUserId
                        ]) { error in
                            if let error = error {
                                completion(.failure(error))
                            } else {
                                completion(.success(()))
                            }
                        }
                    }
                } else {
                    // User does not exist, proceed to save the user ID and date
                    contactListRef.setData([
                        "userId": userId,
                        "dateAdded": Timestamp(date: Date()),
                        "name": name,
                        "email": email,
                        "img": img,
                        "sid": currentUserId
                    ]) { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(()))
                        }
                    }
                }
            }
        } else {
            // Current user is trying to add themselves, do nothing
            completion(.success(()))
        }
    }

    
    //fatch contect list
    
  
    func fetchContactList(completion: @escaping (Result<[MyContacts], Error>) -> Void) {
        guard let userId = currentUser?.id else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }

        let db = Firestore.firestore()
        db.collection("ContactList").whereField("sid", isEqualTo: userId).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documents = snapshot?.documents else {
                completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "No contacts found"])))
                return
            }

            var contacts = [MyContacts]()

            let dispatchGroup = DispatchGroup()
            
            for document in documents {
                guard let contactId = document["userId"] as? String else { continue }
                var contact = MyContacts(
                    id: document.documentID,
                    name: document["name"] as? String ?? "Unknown",
                    email: document["email"] as? String ?? "No Email",
                    imageURL: URL(string: document["img"] as? String ?? "") ?? URL(string: "")!
                )

                // Fetch and calculate balance
                dispatchGroup.enter()
                self.calculateBalance(userId: userId, contactId: contactId) { balance in
                    contact.balance = balance
                    contacts.append(contact)
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                completion(.success(contacts))
            }
        }
    }

    private func calculateBalance(userId: String, contactId: String, completion: @escaping (Float) -> Void) {
        let db = Firestore.firestore()
        let messagesRef = db.collection("messages")
        
        let query1 = messagesRef.whereField("senderId", isEqualTo: userId).whereField("receiverId", isEqualTo: contactId)
        let query2 = messagesRef.whereField("senderId", isEqualTo: contactId).whereField("receiverId", isEqualTo: userId)

        var balance: Float = 0

        query1.getDocuments { snapshot1, error in
            let sumSender = snapshot1?.documents.reduce(0) {
                $0 + (Float(($1.data()["amount"] as? Double ?? 0)))
            } ?? 0
            
            query2.getDocuments { snapshot2, error in
                let sumReceiver = snapshot2?.documents.reduce(0) {
                    $0 + (Float(($1.data()["amount"] as? Double ?? 0)))
                } ?? 0
                
                balance = sumSender - sumReceiver
                completion(balance)
            }
        }
    }

    
    
    func sendMessage(to receiverId: String, text: String, amount: Float?, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let senderId = currentUser?.id else {
                completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])))
                return
            }

            let db = Firestore.firestore()
            let messageData: [String: Any] = [
                "senderId": senderId,
                "receiverId": receiverId,
                "text": text,
                "timestamp": Timestamp(date: Date()),
                "amount": amount ?? NSNull()
            ]

            db.collection("messages").addDocument(data: messageData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }

    func fetchMessages(with contactId: String, completion: @escaping (Result<[ChatMessage], Error>) -> Void) {
        guard let userId = currentUser?.id else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])))
            return
        }

        let db = Firestore.firestore()
        let messagesRef = db.collection("messages")
        
        let query1 = messagesRef.whereField("senderId", isEqualTo: userId).whereField("receiverId", isEqualTo: contactId)
        let query2 = messagesRef.whereField("senderId", isEqualTo: contactId).whereField("receiverId", isEqualTo: userId)

        query1.getDocuments { snapshot1, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            var combinedMessages = snapshot1?.documents.compactMap { doc -> ChatMessage? in
                return self.documentToChatMessage(doc)
            } ?? []

            query2.getDocuments { snapshot2, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                let messagesFromQuery2 = snapshot2?.documents.compactMap { doc -> ChatMessage? in
                    return self.documentToChatMessage(doc)
                } ?? []
                
                combinedMessages.append(contentsOf: messagesFromQuery2)
                combinedMessages.sort { $0.timestamp.dateValue() < $1.timestamp.dateValue() }

                completion(.success(combinedMessages))
            }
        }
    }

    private func documentToChatMessage(_ document: QueryDocumentSnapshot) -> ChatMessage? {
        let data = document.data()
        guard
            let senderId = data["senderId"] as? String,
            let receiverId = data["receiverId"] as? String,
            let text = data["text"] as? String,
            let timestamp = data["timestamp"] as? Timestamp,
            let id = document.documentID as String?
        else {
            return nil
        }
        let amount = data["amount"] as? Float
        return ChatMessage(id: id, senderId: senderId, receiverId: receiverId, text: text, timestamp: timestamp, amount: amount)
    }


    
    func fetchTransactionSums() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user logged in")
            return
        }

        let db = Firestore.firestore()
        
        // Fetch sent messages and sum up the amounts
        db.collection("messages")
            .whereField("senderId", isEqualTo: userId)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching sent messages: \(error.localizedDescription)")
                    return
                }
                
                var totalSent: Double = 0
                var Total: Double = 0
                for document in querySnapshot!.documents {
                    if let amount = document.data()["amount"] as? Double {
                        totalSent += amount
                    }
                }
                
                self.totalSent =  Float(totalSent)
            }
        
        // Fetch received messages and sum up the amounts
        db.collection("messages")
            .whereField("receiverId", isEqualTo: userId)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching received messages: \(error.localizedDescription)")
                    return
                }
                
                var totalReceived: Double = 0
                for document in querySnapshot!.documents {
                    if let amount = document.data()["amount"] as? Double {
                        totalReceived += amount
                    }
                }
                
                self.totalReceived =  Float(totalReceived)
                self.Total = Float(self.totalSent) - Float(totalReceived)
            }
    }

    

}


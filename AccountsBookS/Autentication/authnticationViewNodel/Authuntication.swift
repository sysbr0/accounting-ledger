// Authocation — Author model view

//
//  authVeiwModel.swift
//  firbaseData
//
//  Created by MUHAMMED SABIR on 3.04.2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


protocol AuthnticationFormProtocol {
    var formIsVaied: Bool {get}
}
@MainActor
class AutViewNodel : ObservableObject {
    @Published var userSession : FirebaseAuth.User?
    @Published var curentuser : User? // from model/user
    
    
    init() {
        self.userSession =  Auth.auth().currentUser
        
        
        Task{
            await fatchUser()
        }
    }
    
    
    
    
    
    func signIn(withEnail email :String  , password : String) async  throws  {
        
     
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
    
    
    func createUser(withEnail  email :String  , password : String , fullname : String) async  throws  {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id : result.user.uid, fullname: fullname , email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser) // get informatiom
            await fatchUser()
        }
        catch  {
            print(" codnot create with erroe " + error.localizedDescription)
            
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
    
    func deleteAccount() {
        
    }
    func fatchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else  {return}
        
        guard  let snapshot =  try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.curentuser =  try?  snapshot.data(as: User.self)
        
        
 
    }
}

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
    @Published var showAlert = false
    @Published var darkmode = false {
          didSet {
              UserDefaults.standard.set(darkmode, forKey: "darkmode")
          }
      }
    
    init() {
        self.userSession =  Auth.auth().currentUser
        
        
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
    

}

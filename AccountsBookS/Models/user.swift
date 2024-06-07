//inside model  user
//
//  user.swift
//  firbaseData
//
//  Created by MUHAMMED SABIR on 3.04.2024.
//

import Foundation


struct User : Identifiable , Codable { // id to mach currentUser
    let id : String
    let fullname : String
    let email : String
    let profileImgeURL : URL
    
    var intials : String {
        
        
    let formatter = PersonNameComponentsFormatter()
        if let componnets = formatter.personNameComponents(from: fullname) {
        formatter.style = .abbreviated
        return formatter.string(from: componnets)
    }
        return " "
    }
    
}

extension User {
    static var MOC_USER = User(id: NSUUID().uuidString, fullname: "sys br " , email: "sysbr@gmail.com", profileImgeURL: URL(string : "SYSBR.COM")!)
}
struct MyContacts: Identifiable { // Conform to Identifiable
    let id: String
    let name: String
    let email: String
    let imageURL: URL?
    var balance: Float = 0.0
    
    init(id: String, name: String, email: String, imageURL: URL?) {
        self.id = id
        self.name = name
        self.email = email
        self.imageURL = imageURL
    }
}


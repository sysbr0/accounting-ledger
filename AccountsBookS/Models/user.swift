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

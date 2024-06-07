//
//  AccountsBookSApp.swift
//  AccountsBookS
//
//  Created by MUHAMMED SABIR on 4.04.2024.
//
//

import SwiftUI
import Firebase
@main
struct AccountsBookSApp: App {


    
    @StateObject var veiwModel = AutViewNodel()
    init(){
        FirebaseApp.configure()
        
          
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(veiwModel) // her
       
         
        }
    }
}


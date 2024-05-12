// contant viow
//  ContentView.swift
//  firbaseData1
//
//  Created by MUHAMMED SABIR on 3.04.2024.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel : AutViewNodel
    var body: some View {
        Group {
            if viewModel.userSession != nil  {
                home()
            }
            else {
              loginView()
            }
            
        }}
}

#Preview {
    ContentView()
}

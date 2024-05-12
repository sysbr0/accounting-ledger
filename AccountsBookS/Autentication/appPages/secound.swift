//
//  secound.swift
//  AccountsBookS
//
//  Created by MUHAMMED SABIR on 15.04.2024.
//

import SwiftUI

struct secound: View {
    
    @EnvironmentObject var siewModel: AutViewNodel
    var body: some View {
        Text(siewModel.curentuser?.fullname ?? "np  email")
        
        Button {
            siewModel.signout()
        } label: {
            SettingsLabel(imagename: "power", title: "Log Out", color: Color(.red))
        }
    }
}

#Preview {
    secound()
}

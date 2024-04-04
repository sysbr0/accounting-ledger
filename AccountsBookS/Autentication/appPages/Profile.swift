// Authucation == app page == profile
import SwiftUI

struct UserInfo: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    @State private var isDarkModeEnabled = false // State variable for dark mode
    @EnvironmentObject var veiwModel : AutViewNodel
    var body: some View {
        NavigationView {
            if let user = veiwModel.curentuser {
                List {
                    Section {
                        HStack {
                            Text(user.intials)
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 72 ,height: 72)
                                .background(Color(.systemGray3))
                                .cornerRadius(40)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullname)
                                    .font(.title3)
                                    .bold()
                                    .padding(.top ,4)
                                Text(user.email)
                                    .font(.footnote)
                                    .accentColor(.gray)
                            }
                            .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            Button(action: {
                                // Action for edit button
                            }) {
                                Icons(customIcon: "edit", size: 30, color: Color(.label))
                            }
                        }
                    }
                    
                    Section("General") {
                        HStack(spacing: 189) {
                            SettingsLabel(imagename: "gear", title: "Version", color: Color(.label))
                            Text(appVersion)
                        }
                        
                        HStack {
                            SettingsLabel(imagename: "dark", title: "Dark Mode", color: Color(.label))
                            Toggle(isOn: $isDarkModeEnabled) {
                                // Empty closure for toggle
                            }
                        }
                    }
                    
                    Section("Account") {
                        Button {
                            veiwModel.signout()
                        } label: {
                            SettingsLabel(imagename: "logout", title: "Log Out", color: Color(.red))
                        }
                        
                        
                        Button {
                            
                            
                        } label: {
                            SettingsLabel(imagename: "delete", title: "Remove Account", color: Color(.red))
                        }
                        
                      
                    }
                }
               
            }
        }
    }
}

struct UserInfo_Previews: PreviewProvider {
    static var previews: some View {
        UserInfo()
    }
}

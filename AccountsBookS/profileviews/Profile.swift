// Authucation == app page == profile
import SwiftUI

struct UserInfo: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
// State variable for dark mode
    @EnvironmentObject var veiwModel : AutViewNodel
    @State private var showAlert = false
    var body: some View {
        NavigationView {
            
            if let user = veiwModel.curentuser {
                
                List {
                    Section {
                        HStack {
                            Text(user.intials)
                                .font(.title)
                                .foregroundColor(veiwModel.darkmode ? .white : .black)
                                                              
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
                                   
                                    .accentColor(veiwModel.darkmode ? .white : .black)
                            }
                            .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                           
                            NavigationLink(destination: edit()) {
                                HStack {
                                    Spacer()
                                    Icons(customIcon: "edit", size: 30, color: Color(.label))
                                }
                            }
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("Profile")
                        }
                    }
                    
                    Section("General") {
                        HStack(spacing: 189) {
                            SettingsLabel(imagename: "gear", title: "Version", color: Color(.label))
                            Text(appVersion)
                        }
                        
                        HStack {
                            SettingsLabel(imagename: "dark", title: "Dark Mode", color: Color(.label))
                            Toggle(isOn: $veiwModel.darkmode) {
                                // Empty closure for toggle
                            }
                        }
                    }
                    
                    Section("Account") {
                   
                            Button {
                                
                                
                                showAlert.toggle()
                                
                            } label: {
                                SettingsLabel(imagename: "power", title: "Log Out", color: Color(.red))
                            }
                            .alert("Are you sure?",
                                   isPresented: $showAlert,
                                   actions: {
                                Button("No", role: .cancel) {}
                                Button("Yes", role: .destructive) {
                                    veiwModel.signout()
                                }
                            }, message: {
                                Text("You are going to log out !")
                            })
                            
                            Button {
                                showAlert.toggle()
                            } label: {
                                SettingsLabel(imagename: "DeletePerson", title: "Remove Account", color: Color(.red))
                            }
                            .alert("Are you sure?",
                                   isPresented: $showAlert,
                                   actions: {
                                Button("No", role: .cancel) {}
                                Button("Yes", role: .destructive) {
                                    veiwModel.DeleteAccount()
                                }
                            }, message: {
                                Text("You are going to remove your account!")
                            })
                            
                            
                        
                    }
                }
               
            }
        }
        .preferredColorScheme(veiwModel.darkmode ? .dark : .light)
        .ignoresSafeArea()
        if veiwModel.curentuser == nil {
            Text("Please reopen the application")
        }
            
                
        
        
    
    }
}

struct UserInfo_Previews: PreviewProvider {
    static var previews: some View {
        UserInfo()
    }
}

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AutViewNodel

    var body: some View {
        TabView {
            NavigationView {
                ScrollView {
                    VStack {
                        Text("The time is now")
                        Text("Total Received: \(authViewModel.totalReceived, specifier: "%.2f")")
                            .foregroundColor(authViewModel.totalReceived >= 0 ? .green : .red)
                        Text("Total Sent: \(authViewModel.totalSent, specifier: "%.2f")")
                            .foregroundColor(authViewModel.totalSent >= 0 ? .green : .red)
                        
                    Text("Total Sent: \(authViewModel.Total, specifier: "%.2f")")
                        .foregroundColor(authViewModel.Total >= 0 ? .green : .red)
                    }
                    .navigationBarTitle("Home")
                }
            }
            .tabItem {
                Icons(customIcon: "home", size: 50, color: .black)
            }

            ContactListView(authViewModel: authViewModel)
                .tabItem {
                    Icons(customIcon: "prof", size: 50, color: .black)
                }

            UserView()
                .tabItem {
                    Icons(customIcon: "bell", size: 50, color: .black)
                }

            UserInfo()
                .tabItem {
                    Icons(customIcon: "gear", size: 50, color: .black)
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(authViewModel)  // Ensure environment objects are set
        .onAppear {
            authViewModel.fetchTransactionSums()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(AutViewNodel())
    }
}

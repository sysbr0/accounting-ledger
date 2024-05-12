import SwiftUI
struct home: View {
    var body: some View {
        TabView {
            NavigationView {
                Text("Welcome")
                    .navigationBarTitle("Home")
            }
            .tabItem {
                Icons(customIcon: "home", size: 50, color:.black)
            }

            mainview()
                .tabItem {
                    Icons(customIcon: "prof", size: 50, color:  .black)
                }

            addPeopleview()
                .tabItem {
                    Icons(customIcon: "bell", size: 50, color:  .black)
                }

          

            UserInfo()
                .tabItem {
                    Icons(customIcon: "gear", size: 50, color:  .black)
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

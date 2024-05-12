import SwiftUI



struct forgetpassword: View {
    
    
    @State private var email = ""
    @State private var showAlert = false
    @State private var error:String?
  
    @EnvironmentObject var viewModel : AutViewNodel
    init() {
        // Customize navigation bar title appearance
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont.systemFont(ofSize: 14)] // Set the desired font size here
    }
    
    var body: some View {
        NavigationView {
    
            
            
        
         
                
                
                
                NavigationStack{
                    
                    VStack{
                  
                          
                    }
                
                    
                    
                    VStack{
                        Icons(customIcon: "lock", size: 100, color: .black)
                        Text(" write your Email and you will resive a link to reset your password")
                            .padding(10)
                     
                    }
                    Spacer()
                        VStack(spacing : 12 ){
                           textInput(text: $email,
                                     title: "Email Adress",
                                     placeholder: "name@doman.com")
                           .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                            
                            
                            
                              }
                        .padding(.horizontal)
                        .padding(.bottom ,22)
                        
                       
                           
                    Button {
                        if !email.isEmpty  && email.contains("@") {
                       
                        
                            Task{ try await // becuse we are using asybc away
                                viewModel.ForgetPassword(withEmail: email) }
                        }
                    } label: {
                        HStack {
                            Text("submit")
                                .fontWeight(.semibold)
                            Icons(customIcon: "lock", size: 20, color: Color(.white))
                         
                            
                        }
                        
                        .foregroundColor(Color(.white))
                        .frame(width: 360 ,height: 50)
                        
                    }
                    .background(Color(.black))
                   
                    .opacity(formIsVaied ? 1.0 : 0.5)
                    .border(Color(.label))
                    .cornerRadius(8)
                   
                    Spacer()
                    Spacer()
                    
            
                }
                
            }
        
            
            
            .navigationBarTitle("Forget  Password")
        }
   
    }


extension  forgetpassword  :  AuthnticationFormProtocol {
    var formIsVaied: Bool {
        return !email.isEmpty
        && email.contains("@")
        &&   email.contains(".")
       
    
    }
}

#Preview {
    forgetpassword()
}



import SwiftUI



struct forgetpassword: View {
    
    
    @State private var email = ""
    @State private var showAlert = false
    @State private var error:String?
  
    @EnvironmentObject var viewModel : AutViewNodel

    
    var body: some View {
        NavigationView {
    
            
            
        
         
                
                
                
                NavigationStack{
                    
                    VStack{
                  
                          
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
                        .padding()
                        .alert(isPresented: $viewModel.showAlert) {
                            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
                      
                        }
                        
                        .foregroundColor(Color(.white))
                        .frame(width: 360 ,height: 50)
                        
                    }
                    .background(Color(.black))
                   
              
                    .border(Color(.label))
                    .cornerRadius(8)
                   
                    Spacer()
                    Spacer()
                    
            
                }
                
            }
        
            
            
            .navigationBarTitle("Forget  Password")
        }
   
    }



#Preview {
    forgetpassword()
}



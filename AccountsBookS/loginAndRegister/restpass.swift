import SwiftUI

struct PasswordResetView: View {
    
    
    @State private var email = ""
    @State private var showAlert = false
    @State private var error:String?
    private var valied: Bool {
        return !email.isEmpty && email.contains("@") && email.contains(".")
    }
  
    @ObservedObject var viewModel = AutViewNodel()
    
    var body: some View {
        
        
        
        
        VStack{
            Icons(customIcon: "lock", size: 100, color: .black)
            Text(" write your Email and you will resive a link to reset your password")
                .padding(10)
         
        }
        Spacer()
     
        VStack {
            
            
            textInput(text: $email,
                      title: "Email Adress",
                      placeholder: "name@doman.com")
            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
        
            
             
            Button(action: {
                viewModel.resetPassword(email: email)
            }) {
                HStack {
                    Text("submit")
                        .fontWeight(.semibold)
                    Icons(customIcon: "lock", size: 20, color: Color(.white))
                 
                          }
                
                .foregroundColor(Color(.white))
                .frame(width: 360 ,height: 50)
            }
            .disabled(!valied)
            .background(Color(.black))
           
           
            .border(Color(.label))
            .cornerRadius(8)
            .opacity(valied ? 1.0 : 0.5)
            .padding()
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
            }
            
            
        }
        .padding()
        Spacer()
    }
}





struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView()
    }
}

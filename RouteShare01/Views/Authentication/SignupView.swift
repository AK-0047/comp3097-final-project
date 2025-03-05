//import SwiftUI
//
//struct SignupView: View {
//    @State private var fullName: String = ""
//    @State private var email: String = ""
//    @State private var password: String = ""
//    @State private var confirmPassword: String = ""
//    
//    @Environment(\.presentationMode) var presentationMode
//
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 25) {
//                Spacer()
//                
//                VStack(spacing: 8) {
//                    Text("Join RouteShare")
//                        .font(.title2)
//                        .fontWeight(.medium)
//                        .foregroundColor(AppColors.contentText.opacity(0.8))
//                    
//                    Text("Create Your Account")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .foregroundColor(AppColors.contentText)
//                }
//                .multilineTextAlignment(.center)
//                
//                VStack(spacing: 15) {
//                    CustomTextField(icon: "person.fill", placeholder: "Full Name", text: $fullName)
//                    CustomTextField(icon: "envelope.fill", placeholder: "Email", text: $email)
//                    CustomTextField(icon: "lock.fill", placeholder: "Password", text: $password, isSecure: true)
//                    CustomTextField(icon: "lock.fill", placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)
//                }
//                .padding(.horizontal)
//                
//                Button(action: {
//                    if password == confirmPassword {
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                }) {
//                    CustomButton(title: "Sign Up", action: {
//                        if password == confirmPassword {
//                            presentationMode.wrappedValue.dismiss()
//                        }
//                    })
//                }
//                .padding(.horizontal)
//                .disabled(email.isEmpty || password.isEmpty || fullName.isEmpty || confirmPassword.isEmpty || password != confirmPassword)
//                .opacity(email.isEmpty || password.isEmpty || fullName.isEmpty || confirmPassword.isEmpty || password != confirmPassword ? 0.6 : 1.0)
//                
//                NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
//                    Text("Already have an account? Login")
//                        .foregroundColor(AppColors.contentText.opacity(0.7))
//                        .font(.footnote)
//                }
//                .padding(.top, 8)
//                
//                Spacer()
//            }
//            .padding()
//            .background(
//                AppColors.background
//                    .edgesIgnoringSafeArea(.all)
//            )
//        }
//        .navigationBarBackButtonHidden(true) // Hides the back button
//    }
//}
//
//// Preview
//struct SignupView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignupView()
//    }
//}


import SwiftUI

struct SignupView: View {
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Join RouteShare")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(AppColors.contentText.opacity(0.8))
                    
                    Text("Create Your Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.contentText)
                }
                .multilineTextAlignment(.center)
                
                VStack(spacing: 15) {
                    CustomTextField(icon: "person.fill", placeholder: "Full Name", text: $fullName)
                    CustomTextField(icon: "envelope.fill", placeholder: "Email", text: $email)
                    CustomTextField(icon: "lock.fill", placeholder: "Password", text: $password, isSecure: true)
                    CustomTextField(icon: "lock.fill", placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)
                }
                .padding(.horizontal)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 5)
                }
                
                Button(action: signUp) {
                    CustomButton(title: "Sign Up", action: signUp)
                }
                .padding(.horizontal)
                .disabled(email.isEmpty || password.isEmpty || fullName.isEmpty || confirmPassword.isEmpty || password != confirmPassword)
                .opacity(email.isEmpty || password.isEmpty || fullName.isEmpty || confirmPassword.isEmpty || password != confirmPassword ? 0.6 : 1.0)
                
                NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                    Text("Already have an account? Login")
                        .foregroundColor(AppColors.contentText.opacity(0.7))
                        .font(.footnote)
                }
                .padding(.top, 8)
                
                Spacer()
            }
            .padding()
            .background(AppColors.background.edgesIgnoringSafeArea(.all))
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func signUp() {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        FirebaseAuthService.shared.signUp(fullName: fullName, email: email, password: password) { result in
            switch result {
            case .success(let user):
                // Save user data to Firestore
                FirestoreService.shared.saveUser(user: user) { firestoreResult in
                    switch firestoreResult {
                    case .success:
                        presentationMode.wrappedValue.dismiss()  // Redirect to login
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}

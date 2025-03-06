//import SwiftUI
//
//struct LoginView: View {
//    @State private var email = ""
//    @State private var password = ""
//    @State private var navigateToHome = false
//
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 20) {
//                Spacer()
//                
//                VStack(spacing: 8) {
//                    Text("Welcome To")
//                        .font(.title2)
//                        .fontWeight(.medium)
//                        .foregroundColor(AppColors.contentText.opacity(0.8))
//                    
//                    Text("RouteShare!")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .foregroundColor(AppColors.contentText)
//                }
//                .multilineTextAlignment(.center)
//                
//                Image("login_illustration")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 220)
//                    .padding(.vertical, 10)
//                
//                VStack(spacing: 15) {
//                    CustomTextField(icon: "envelope", placeholder: "Email", text: $email)
//                    CustomTextField(icon: "lock", placeholder: "Password", text: $password, isSecure: true)
//                }
//                .padding(.horizontal)
//                
//                Button(action: {
//                    navigateToHome = true
//                }) {
//                    CustomButton(title: "Login", action: {
//                        navigateToHome = true
//                    })
//                }
//                .padding(.horizontal)
//                .padding(.top, 15)
//                
//                NavigationLink(destination: SignupView()) {
//                    Text("Don't have an account? Sign Up")
//                        .foregroundColor(AppColors.contentText.opacity(0.7))
//                        .font(.footnote)
//                }
//                .padding(.top, 8)
//                
//                Spacer()
//                
//                NavigationLink(destination: HomeView(), isActive: $navigateToHome) {
//                    EmptyView()
//                }
//            }
//            .padding()
//            .background(
//                AppColors.background
//                    .edgesIgnoringSafeArea(.all)
//            )
//        }
//    }
//}


import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var navigateToHome = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Welcome To")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(AppColors.contentText.opacity(0.8))
                    
                    Text("RouteShare!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.contentText)
                }
                .multilineTextAlignment(.center)
                
                Image("login_illustration")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220)
                    .padding(.vertical, 10)
                
                VStack(spacing: 15) {
                    CustomTextField(icon: "envelope", placeholder: "Email", text: $email)
                    CustomTextField(icon: "lock", placeholder: "Password", text: $password, isSecure: true)
                }
                .padding(.horizontal)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 5)
                }
                
                Button(action: logIn) {
                    CustomButton(title: "Login", action: logIn)
                }
                .padding(.horizontal)
                .padding(.top, 15)
                
                NavigationLink(destination: SignupView()) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(AppColors.contentText.opacity(0.7))
                        .font(.footnote)
                }
                .padding(.top, 8)
                
                Spacer()
                
                NavigationLink(destination: HomeView(), isActive: $navigateToHome) {
                    EmptyView()
                }
            }
            .padding()
            .background(AppColors.background.edgesIgnoringSafeArea(.all))
        }
    }
    
    private func logIn() {
        FirebaseAuthService.shared.loginUser(email: email, password: password) { result in
            switch result {
            case .success:
                navigateToHome = true
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}

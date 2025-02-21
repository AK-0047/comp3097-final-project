//
//  LoginView.swift
//  routeshare
//
//  Created by Anshul Dharmendra Kamboya on 2025-02-21.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Welcome to RouteShare")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                CustomTextField(placeholder: "Email", text: $email, isSecure: false)
                CustomTextField(placeholder: "Password", text: $password, isSecure: true)
                
                CustomButton(title: "Continue", backgroundColor: .blue) {
                    // Implement login logic here
                    // For demonstration, simply mark as logged in
                    isLoggedIn = true
                }
                .padding(.top, 10)
                
                NavigationLink("Forgot Password?", destination: ForgotPasswordView())
                    .font(.footnote)
                    .foregroundColor(.blue)
                
                HStack(spacing: 20) {
                    Button(action: {
                        // Apple sign-in logic
                    }) {
                        HStack {
                            Image(systemName: "applelogo")
                            Text("Continue with Apple")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(8)
                    }
                    
                    Button(action: {
                        // Google sign-in logic
                    }) {
                        HStack {
                            Image(systemName: "globe")
                            Text("Continue with Google")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                    }
                }
                
                HStack {
                    Text("Don't have an account?")
                        .font(.footnote)
                    NavigationLink("Sign Up", destination: SignupView())
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
                .padding(.top, 20)
                
                Spacer()
                
                // Hidden NavigationLink to HomePageView when logged in
                NavigationLink(destination: HomePageView(), isActive: $isLoggedIn) {
                    EmptyView()
                }
            }
            .padding(.horizontal)
            .navigationBarHidden(true)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

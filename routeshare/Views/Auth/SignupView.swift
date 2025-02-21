//
//  SignupView.swift
//  routeshare
//
//  Created by Anshul Dharmendra Kamboya on 2025-02-21.
//

import SwiftUI

struct SignupView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isSignedUp: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Create an Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                CustomTextField(placeholder: "First Name", text: $firstName, isSecure: false)
                CustomTextField(placeholder: "Last Name", text: $lastName, isSecure: false)
                CustomTextField(placeholder: "Email", text: $email, isSecure: false)
                CustomTextField(placeholder: "Password", text: $password, isSecure: true)
                CustomTextField(placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)
                
                Text("By clicking continue, you agree to our Terms of Service and Privacy Policy.")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                CustomButton(title: "Continue", backgroundColor: .blue) {
                    // Implement signup logic here
                    // For demonstration, mark as signed up
                    isSignedUp = true
                }
                .padding(.top, 10)
                
                HStack {
                    Text("Already have an account?")
                        .font(.footnote)
                    NavigationLink("Login", destination: LoginView())
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
                .padding(.top, 20)
                
                Spacer()
                
                NavigationLink(destination: HomePageView(), isActive: $isSignedUp) {
                    EmptyView()
                }
            }
            .padding(.horizontal)
            .navigationBarTitle("Sign Up", displayMode: .inline)
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}

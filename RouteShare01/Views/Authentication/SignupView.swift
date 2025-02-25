//
//  SignupView.swift
//  RouteShare01
//
//  Created by Anshul Dharmendra Kamboya on 2025-02-24.
//

import SwiftUI

struct SignupView: View {
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            AppColors.background
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // Title
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.contentText)

                // Full Name
                CustomTextField(icon: "person.fill", placeholder: "Full Name", text: $fullName, isSecure: false)
                // Email
                CustomTextField(icon: "envelope.fill", placeholder: "Email", text: $email, isSecure: false)

                // Password
                CustomTextField(icon: "lock.fill", placeholder: "Password", text: $password, isSecure: true)

                // Confirm Password
                CustomTextField(icon: "lock.fill", placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)

                // Signup Button
                Button(action: {
                    if password == confirmPassword {
                        // Add signup logic here
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(AppColors.buttonText)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.buttonBackground)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(email.isEmpty || password.isEmpty || fullName.isEmpty || confirmPassword.isEmpty || password != confirmPassword)
                .opacity(email.isEmpty || password.isEmpty || fullName.isEmpty || confirmPassword.isEmpty || password != confirmPassword ? 0.6 : 1.0)

                // Back to Login
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Already have an account? Login")
                        .foregroundColor(AppColors.contentText)
                        .font(.subheadline)
                }
            }
            .padding()
        }
    }
}

// Preview
struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}

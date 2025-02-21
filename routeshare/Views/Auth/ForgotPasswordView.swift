//
//  ForgotPasswordView.swift
//  routeshare
//
//  Created by Anshul Dharmendra Kamboya on 2025-02-21.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var statusMessage: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Forgot Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                Text("Enter your email address to reset your password.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                CustomTextField(placeholder: "Email", text: $email, isSecure: false)
                
                CustomButton(title: "Reset Password", backgroundColor: .blue) {
                    // Implement reset logic here
                    statusMessage = "If this email exists, you'll receive a reset link."
                }
                
                if !statusMessage.isEmpty {
                    Text(statusMessage)
                        .foregroundColor(.green)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Forgot Password")
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}

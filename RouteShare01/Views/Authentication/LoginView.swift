//
//  LoginView.swift
//  RouteShare01
//
//  Created by Anshul Dharmendra Kamboya on 2025-02-24.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var navigateToHome = false

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                Text("Welcome To RouteShare!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.contentText)

                Image("login_illustration") // Replace with your actual asset
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.bottom, 20)

                VStack(spacing: 15) {
                    // Email TextField with updated styling
                    TextField("", text: $email)
                        .placeholder(when: email.isEmpty) {
                            Text("Email")
                                .foregroundColor(AppColors.contentText.opacity(0.5))
                        }
                        .padding()
                        .background(AppColors.background)
                        .foregroundColor(AppColors.contentText)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(AppColors.contentText, lineWidth: 1)
                        )

                    // Password SecureField with updated styling
                    SecureField("", text: $password)
                        .placeholder(when: password.isEmpty) {
                            Text("Password")
                                .foregroundColor(AppColors.contentText.opacity(0.5))
                        }
                        .padding()
                        .background(AppColors.background)
                        .foregroundColor(AppColors.contentText)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(AppColors.contentText, lineWidth: 1)
                        )
                }
                .padding(.horizontal)

                // Login Button with updated colors
                Button(action: {
                    navigateToHome = true // Triggers navigation to HomeView
                }) {
                    Text("Login")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.buttonText)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColors.buttonBackground)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
                .padding(.horizontal)
                .padding(.top, 20)

                NavigationLink(destination: SignupView()) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(AppColors.contentText)
                        .font(.footnote)
                }
                .padding(.top, 10)

                Spacer()

                // Navigation link to HomeView (prevents back navigation)
                NavigationLink(destination: HomeView(), isActive: $navigateToHome) {
                    EmptyView()
                }
            }
            .padding()
            .background(
                AppColors.background
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
}

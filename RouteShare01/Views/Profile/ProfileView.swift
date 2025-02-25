//
//  ProfileView.swift
//  RouteShare01
//
//  Created by Anshul Dharmendra Kamboya on 2025-02-24.
//

import SwiftUI

struct ProfileView: View {
    @State private var isLoggedOut = false

    var body: some View {
        NavigationView {
            VStack {
                // Profile Header
                VStack {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(AppColors.contentText)
                        .padding(.bottom, 10)
                    
                    Text("John Doe")  // Replace with actual user name
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.contentText)
                    
                    Text("johndoe@example.com")  // Replace with actual email
                        .font(.subheadline)
                        .foregroundColor(AppColors.contentText.opacity(0.7))
                }
                .padding()
                .background(AppColors.background)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(AppColors.buttonBackground, lineWidth: 1)
                )
                .shadow(radius: 3)
                .padding(.horizontal)

                // Account Options List
                VStack(spacing: 15) {
                    AccountOptionRow(icon: "pencil", title: "Edit Profile")
                    AccountOptionRow(icon: "creditcard.fill", title: "Payment Methods")
                    AccountOptionRow(icon: "clock.fill", title: "Ride History")
                    AccountOptionRow(icon: "gearshape.fill", title: "Settings")

                    // Logout Button
                    Button(action: logoutUser) {
                        HStack {
                            Image(systemName: "power")
                                .foregroundColor(AppColors.buttonText)
                            Text("Logout")
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.buttonText)
                            Spacer()
                        }
                        .padding()
                        .background(AppColors.buttonBackground)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
            .background(AppColors.background.edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $isLoggedOut) {
                LoginView() // Redirects to Login screen after logout
            }
        }
    }

    private func logoutUser() {
        isLoggedOut = true
    }
}

// Reusable Component for Account Options
struct AccountOptionRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(AppColors.contentText)
            Text(title)
                .fontWeight(.medium)
                .foregroundColor(AppColors.contentText)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(AppColors.contentText.opacity(0.7))
        }
        .padding()
        .background(AppColors.background)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppColors.buttonBackground, lineWidth: 1)
        )
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

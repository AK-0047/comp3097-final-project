//
//  HomeView.swift
//  RouteShare01
//
//  Created by Anshul Dharmendra Kamboya on 2025-02-24.
//

import SwiftUI

struct HomeView: View {
    init() {
        // Set the Tab Bar's background to cream
        UITabBar.appearance().backgroundColor = UIColor(AppColors.background)
    }
    
    var body: some View {
        TabView {
            HomeContentView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            PostRideView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Post Trip")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .accentColor(AppColors.buttonBackground) // Orange accent for selected icons
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct HomeContentView: View {
    var body: some View {
        VStack {
            Image("homeBanner") // Add an actual image to Assets.xcassets
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .cornerRadius(15)
                .padding()

            Text("Welcome to RouteShare")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(AppColors.contentText) // Brown text for main welcome
                .padding(.bottom, 5)

            Text("Find rides, post trips, and connect with travelers.")
                .font(.body)
                .foregroundColor(AppColors.contentText.opacity(0.8)) // Brown text with slight opacity
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            Spacer()

            HStack {
                Button(action: {}) {
                    Text("Post a Trip")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColors.buttonBackground) // Orange background for button
                        .foregroundColor(AppColors.buttonText) // White text for button
                        .cornerRadius(10)
                }
                Button(action: {}) {
                    Text("Search Rides")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColors.buttonBackground) // Orange background for button
                        .foregroundColor(AppColors.buttonText) // White text for button
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .padding()
        .background(AppColors.background.edgesIgnoringSafeArea(.all)) // Cream background
    }
}

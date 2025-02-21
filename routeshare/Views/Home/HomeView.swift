//
//  HomeView.swift
//  routeshare
//
//  Created by Anshul Dharmendra Kamboya on 2025-02-21.
//

import SwiftUI

struct HomePageView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Top Bar with Search and Post buttons
                TopBarView()
                    .padding(.top, 10)
                
                // Main Content Area wrapped in a safe area container
                VStack {
                    Spacer()
                    Text("Welcome to RouteShare!")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal)
                .background(Color(UIColor.systemBackground))
                
                // Bottom Navigation Bar
                BottomNavBar()
                    .padding(.bottom, 10)
            }
            .ignoresSafeArea(edges: [.bottom])  // Let BottomNavBar handle safe area if needed
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true) // Hide the back button to make this the root
        }
    }
}

struct TopBarView: View {
    var body: some View {
        HStack {
            // Search Button
            NavigationLink(destination: SearchView()) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                        .fontWeight(.semibold)
                }
                .padding(10)
                .background(Color.blue.opacity(0.2))
                .foregroundColor(.blue)
                .cornerRadius(8)
            }
            
            Spacer()
            
            // Post Button
            NavigationLink(destination: PostTripView()) {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Post")
                        .fontWeight(.semibold)
                }
                .padding(10)
                .background(Color.green.opacity(0.2))
                .foregroundColor(.green)
                .cornerRadius(8)
            }
        }
        .padding(.horizontal)
    }
}

struct BottomNavBar: View {
    var body: some View {
        HStack {
            Spacer()
            
            // Home Button
            NavigationLink(destination: HomePageView()) {
                VStack {
                    Image(systemName: "house.fill")
                        .foregroundColor(.blue)
                    Text("Home")
                        .font(.caption)
                }
            }
            
            Spacer()
            
            // Trips Button
            NavigationLink(destination: TripsView()) {
                VStack {
                    Image(systemName: "car.fill")
                        .foregroundColor(.orange)
                    Text("Trips")
                        .font(.caption)
                }
            }
            
            Spacer()
            
            // Account Button
            NavigationLink(destination: AccountView()) {
                VStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.purple)
                    Text("Profile")
                        .font(.caption)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.2))
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}

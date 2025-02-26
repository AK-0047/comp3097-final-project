import SwiftUI
import Foundation

let sampleRides: [Ride] = [
    Ride(id: "1", origin: "Montreal", destination: "Toronto", price: "$50", driverName: "John Doe"),
    Ride(id: "2", origin: "Calgary", destination: "Vancouver", price: "$75", driverName: "Jane Smith"),
    Ride(id: "3", origin: "Boston", destination: "New York", price: "$40", driverName: "Michael Johnson")
]

struct HomeView: View {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AppColors.background)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
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
        .accentColor(AppColors.buttonBackground)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct HomeContentView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Fixed Header
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(AppColors.background)
                    .frame(height: 90)
                    .shadow(radius: 5)
                    .edgesIgnoringSafeArea(.top)
                
                HStack(spacing: 8) {
                    Image(systemName: "car.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(AppColors.buttonBackground)
                    
                    Text("RouteShare")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.contentText)
                }
                .padding(.bottom, 5)
            }
            .frame(maxWidth: .infinity)
            .zIndex(1)
            
            // Scrollable Content
            ScrollView {
                VStack(spacing: 20) {
                    // Hero Section with Image Only
                    Image("dummyImage") // Replace with actual image asset
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    
                    Text("Plan your perfect trip, find trusted rides, and travel with ease.")
                        .font(.body)
                        .foregroundColor(AppColors.contentText.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    // Featured Trips
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Popular Rides")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.contentText)
                            .padding(.leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(sampleRides, id: \..id) { ride in
                                    RideCardView(ride: ride)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Quick Action Buttons
                    VStack(spacing: 12) {
                        HStack(spacing: 15) {
                            CustomButton(title: "Find Rides", action: {})
                            CustomButton(title: "Offer a Ride", action: {})
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Travel Tips Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Travel Tips")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.contentText)
                            .padding(.leading)
                        
                        Text("✅ Always verify the driver's profile before booking.\n✅ Plan your trip ahead to find the best matches.\n✅ Communicate clearly with your driver for a smooth experience.")
                            .font(.body)
                            .foregroundColor(AppColors.contentText.opacity(0.8))
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 10)
                }
                .background(AppColors.background)
                .cornerRadius(10)
                .shadow(radius: 3)
                .padding(.vertical)
            }
        }
        .background(AppColors.background.edgesIgnoringSafeArea(.all))
    }
}

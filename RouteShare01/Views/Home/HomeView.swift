import SwiftUI
import Foundation

let sampleRides: [Ride] = [
    Ride(id: "1", origin: "Montreal", destination: "Toronto", price: "$50", driverName: "John Doe"),
    Ride(id: "2", origin: "Calgary", destination: "Vancouver", price: "$75", driverName: "Jane Smith"),
    Ride(id: "3", origin: "Boston", destination: "New York", price: "$40", driverName: "Michael Johnson")
]

struct HomeView: View {
    @State private var selectedTab = 0  // Track the selected tab

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AppColors.background)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeContentView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(1)
            
            PostRideView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Post Trip")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(AppColors.buttonBackground)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct HomeContentView: View {
    @Binding var selectedTab: Int  // Bind to HomeView's selectedTab

    var body: some View {
        VStack(spacing: 0) {
            // Fixed Header
            VStack(spacing: 0) {
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
                .padding(.top, 20)
                .padding(.bottom, 10)
            }
            .frame(maxWidth: .infinity)
            .background(AppColors.background)
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
                                ForEach(sampleRides, id: \.id) { ride in
                                    RideCardView(ride: ride)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // Quick Action Buttons (Navigate by Updating Selected Tab)
                    HStack(spacing: 15) {
                        CustomButton(title: "Find Rides") {
                            selectedTab = 1  // Switch to SearchView
                        }
                        CustomButton(title: "Offer a Ride") {
                            selectedTab = 2  // Switch to PostRideView
                        }
                    }
                    .padding(.horizontal, 20)

                    // Travel Tips Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Travel Tips")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.contentText)
                            .padding(.leading)

                        VStack(alignment: .leading, spacing: 5) {
                            TravelTipItem(icon: "checkmark.circle.fill", text: "Always verify the driver's profile before booking.")
                            TravelTipItem(icon: "calendar", text: "Plan your trip ahead to find the best matches.")
                            TravelTipItem(icon: "message.fill", text: "Communicate clearly with your driver for a smooth experience.")
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 10)
                }
                .padding(.vertical)
            }
            .background(AppColors.background)
        }
        .background(AppColors.background.edgesIgnoringSafeArea(.all))
    }
}

// Travel Tip Row Component
struct TravelTipItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.green)
            Text(text)
                .foregroundColor(AppColors.contentText.opacity(0.8))
                .font(.body)
        }
    }
}

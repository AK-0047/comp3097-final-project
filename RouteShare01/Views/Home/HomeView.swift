import SwiftUI
import Foundation
import FirebaseFirestore

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
                    Image(systemName: "car.circle.fill")
                    Text("Post Trip")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(AppColors.accentColor)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct HomeContentView: View {
    @Binding var selectedTab: Int  // Bind to HomeView's selectedTab
    @State private var rides: [Ride] = [] // Store fetched rides
    @State private var isLoading = true   // Loading state

    var body: some View {
        VStack(spacing: 0) {
            // Fixed Header with updated design
            HStack {
                Image(systemName: "figure.walk.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.accentColor)
                    
                Text("RouteShare")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.contentText)
                
                Spacer()
                
                Image(systemName: "bell.fill")
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.contentText.opacity(0.7))
                    .padding(.trailing, 5)
            }
            .padding(.horizontal)
            .padding(.top, 15)
            .padding(.bottom, 10)
            .background(
                Rectangle()
                    .fill(AppColors.background)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
            )
            .zIndex(1)

            // Scrollable Content
            ScrollView {
                VStack(spacing: 25) {
                    // Hero Section with improved design
                    ZStack(alignment: .bottom) {
                        Image("dummyImage") // Replace with actual image asset
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.5)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        Text("Discover your next adventure")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.bottom, 16)
                    }
                    .padding(.horizontal)
                    
                    // Travel motto with updated style
                    HStack {
                        Text("Travel together.")
                            .fontWeight(.semibold)
                        Text("Save together.")
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.accentColor)
                    }
                    .font(.subheadline)
                    .padding(.vertical, 5)

                    // Quick Action Buttons with updated design
                    HStack(spacing: 15) {
                        ActionButton(icon: "magnifyingglass", title: "Find Rides") {
                            selectedTab = 1  // Switch to SearchView
                        }
                        
                        ActionButton(icon: "car.fill", title: "Offer a Ride") {
                            selectedTab = 2  // Switch to PostRideView
                        }
                    }
                    .padding(.horizontal)
                    
                    // Featured Trips with updated design
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Popular Rides")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.contentText)
                            
                            Spacer()
                            
                            Button(action: {
                                // View all action
                            }) {
                                Text("View all")
                                    .font(.subheadline)
                                    .foregroundColor(AppColors.accentColor)
                            }
                        }
                        .padding(.horizontal)

                        if isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .scaleEffect(1.2)
                                    .padding()
                                Spacer()
                            }
                        } else if rides.isEmpty {
                            EmptyStateView(
                                icon: "car.fill",
                                message: "No rides available yet. Be the first to offer one!"
                            )
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(rides, id: \.id) { ride in
                                        RideCardView(ride: ride)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }

                    // Travel Tips Section with updated design
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Travel Smart")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.contentText)
                            .padding(.horizontal)

                        VStack(spacing: 12) {
                            TravelTipCard(
                                icon: "person.fill.checkmark",
                                title: "Verify Profiles",
                                description: "Always check driver ratings and reviews before booking."
                            )
                            
                            TravelTipCard(
                                icon: "calendar",
                                title: "Plan Ahead",
                                description: "Book early to find the best matches for your journey."
                            )
                            
                            TravelTipCard(
                                icon: "message.fill",
                                title: "Stay Connected",
                                description: "Keep in touch with your driver for a smooth trip."
                            )
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 5)
                }
                .padding(.vertical, 15)
            }
            .background(AppColors.background)
        }
        .background(AppColors.background.edgesIgnoringSafeArea(.all))
        .onAppear {
            fetchRidesFromFirestore()
        }
    }

    // Fetch rides from Firestore (unchanged)
    private func fetchRidesFromFirestore() {
        FirestoreService.shared.fetchAllRides { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedRides):
                    self.rides = fetchedRides
                    self.isLoading = false
                case .failure(let error):
                    print("Error fetching rides: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }
        }
    }
}

// New Action Button Component
struct ActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(title)
                    .fontWeight(.medium)
            }
            .foregroundColor(AppColors.buttonText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.buttonBackground)
            )
            .shadow(color: AppColors.buttonBackground.opacity(0.3), radius: 5, x: 0, y: 3)
        }
    }
}

// New Travel Tip Card Component
struct TravelTipCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(AppColors.accentColor)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.contentText)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(AppColors.contentText.opacity(0.8))
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}

// New Empty State Component
struct EmptyStateView: View {
    let icon: String
    let message: String
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(AppColors.contentText.opacity(0.3))
            
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(AppColors.contentText.opacity(0.6))
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
    }
}

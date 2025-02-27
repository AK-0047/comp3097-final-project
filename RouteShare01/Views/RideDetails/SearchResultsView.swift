import SwiftUI

struct SearchResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    var searchQuery: String
    @State private var selectedRide: Ride? = nil

    let sampleRides: [Ride] = [
        Ride(id: "1", origin: "Windsor", destination: "Guelph", price: "$25", driverName: "John Doe"),
        Ride(id: "2", origin: "Ottawa", destination: "Montreal", price: "$40", driverName: "Emily Smith"),
        Ride(id: "3", origin: "Toronto", destination: "Kitchner", price: "$35", driverName: "Alex Brown")
    ]

    var body: some View {
        ZStack {
            // Background
            AppColors.background.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header with map-inspired design
                ZStack {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(AppColors.contentText)
                                .padding(12)
                                .background(
                                    Circle()
                                        .fill(AppColors.background)
                                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                )
                        }
                        
                        Spacer()
                        
                        Text("Search Results")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(AppColors.contentText)
                        
                        Spacer()
                        
                        // Decorative element for balance
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 40, height: 40)
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.top, 10)
                .padding(.bottom, 15)
                
                // Journey visualization - Staggered card layout
                ScrollView {
                    VStack(spacing: 24) {
                        ForEach(sampleRides) { ride in
                            RideCardRow(ride: ride)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        selectedRide = selectedRide?.id == ride.id ? nil : ride
                                    }
                                }
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct RideCardRow: View {
    let ride: Ride
    
    var body: some View {
        HStack(spacing: 0) {
            // Visual route indicator
            RouteIndicator()
                .padding(.leading, 16)
                .padding(.trailing, 8)
            
            // Enhanced ride card
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.background)
                    .shadow(color: Color.black.opacity(0.12), radius: 8, x: 2, y: 3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.buttonBackground.opacity(0.3), lineWidth: 1)
                    )
                
                VStack(alignment: .leading, spacing: 12) {
                    // Route header
                    HStack {
                        // Origin and destination with visual separator
                        Text(ride.origin)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(AppColors.contentText)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.buttonBackground)
                            .padding(.horizontal, 4)
                        
                        Text(ride.destination)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(AppColors.contentText)
                        
                        Spacer()
                        
                        // Price tag with enhanced styling
                        Text(ride.price)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppColors.buttonText)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(AppColors.buttonBackground)
                                    .shadow(color: AppColors.buttonBackground.opacity(0.4), radius: 3, x: 0, y: 2)
                            )
                    }
                    
                    Divider()
                        .background(AppColors.contentText.opacity(0.1))
                    
                    // Driver info with icon
                    HStack {
                        Image(systemName: "person.fill")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.buttonBackground)
                        
                        Text(ride.driverName)
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.contentText.opacity(0.8))
                        
                        Spacer()
                        
                        // Quick action buttons
                        HStack(spacing: 16) {
                            Button(action: {}) {
                                Image(systemName: "info.circle")
                                    .font(.system(size: 18))
                                    .foregroundColor(AppColors.contentText.opacity(0.6))
                            }
                            
                            Button(action: {}) {
                                Image(systemName: "star")
                                    .font(.system(size: 18))
                                    .foregroundColor(AppColors.contentText.opacity(0.6))
                            }
                        }
                    }
                }
                .padding(16)
            }
            .padding(.trailing, 16)
        }
    }
}

struct RouteIndicator: View {
    var body: some View {
        VStack(spacing: 0) {
            // Origin marker
            ZStack {
                Circle()
                    .stroke(AppColors.buttonBackground, lineWidth: 2)
                    .frame(width: 20, height: 20)
                
                Circle()
                    .fill(AppColors.background)
                    .frame(width: 12, height: 12)
            }
            
            // Route line
            Rectangle()
                .fill(AppColors.buttonBackground)
                .frame(width: 2, height: 40)
            
            // Destination marker
            Circle()
                .fill(AppColors.buttonBackground)
                .frame(width: 20, height: 20)
                .overlay(
                    Circle()
                        .fill(AppColors.background)
                        .frame(width: 8, height: 8)
                )
        }
    }
}

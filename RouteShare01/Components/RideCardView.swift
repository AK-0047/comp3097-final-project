import SwiftUI

struct RideCardView: View {
    var ride: Ride
    @State private var driverName: String = "Loading..." // Placeholder while fetching
    @State private var isExpanded: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Top ribbon - could be used to show ride status
            Rectangle()
                .fill(AppColors.buttonBackground)
                .frame(height: 4)
                .cornerRadius(12, corners: [.topLeft, .topRight])
            
            // Main card content
            VStack(alignment: .leading, spacing: 16) {
                // Origin to destination with route visualization
                HStack(spacing: 16) {
                    // Route visualization
                    VStack(spacing: 2) {
                        Circle()
                            .fill(AppColors.buttonBackground)
                            .frame(width: 10, height: 10)
                        
                        Rectangle()
                            .fill(AppColors.buttonBackground.opacity(0.5))
                            .frame(width: 2, height: 25)
                            .padding(.horizontal, 4)
                        
                        Circle()
                            .fill(AppColors.buttonBackground)
                            .frame(width: 10, height: 10)
                    }
                    .padding(.vertical, 4)
                    
                    // Origin/Destination text
                    VStack(alignment: .leading, spacing: 24) {
                        Text(ride.origin)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(AppColors.contentText)
                        
                        Text(ride.destination)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(AppColors.contentText)
                    }
                    
                    Spacer()
                    
                    // Price badge
                    Text(String(format: "$%.2f", ride.price))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.buttonText)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AppColors.buttonBackground)
                                .shadow(color: AppColors.buttonBackground.opacity(0.3), radius: 2, x: 0, y: 1)
                        )
                }
                
                Divider()
                    .background(AppColors.contentText.opacity(0.2))
                
                // Driver info with icon and verification badge
                HStack {
                    Image(systemName: "person.circle.fill")
                        .font(.title2)
                        .foregroundColor(AppColors.buttonBackground.opacity(0.8))
                    
                    Text(driverName)
                        .font(.subheadline)
                        .foregroundColor(AppColors.contentText)
                    
                    Spacer()
                    
                    // Verification badge
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.shield.fill")
                            .font(.caption)
                            .foregroundColor(Color.green)
                        
                        Text("Verified")
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(AppColors.contentText.opacity(0.8))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.green.opacity(0.15))
                    )
                }
                
                // Action buttons
                if isExpanded {
                    HStack(spacing: 12) {
                        Button(action: {
                            // Book ride action
                        }) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Book Ride")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(AppColors.buttonBackground)
                            .foregroundColor(AppColors.buttonText)
                            .cornerRadius(8)
                            .shadow(color: AppColors.buttonBackground.opacity(0.3), radius: 2, x: 0, y: 1)
                        }
                        
                        Button(action: {
                            // View details action
                        }) {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                Text("Details")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(AppColors.contentText)
                            .cornerRadius(8)
                        }
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                }
            }
            .padding(16)
            .background(AppColors.background)
            
            // Expand/collapse button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(AppColors.contentText.opacity(0.6))
                    
                    Spacer()
                }
                .frame(height: 24)
                .background(colorScheme == .dark ? Color.black.opacity(0.3) : Color.gray.opacity(0.1))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .background(AppColors.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: colorScheme == .dark ? Color.black.opacity(0.5) : Color.black.opacity(0.1),
                radius: 5, x: 0, y: 2)
        .padding(.horizontal)
        .onAppear {
            fetchDriverName()
        }
    }
    
    private func fetchDriverName() {
        FirestoreService.shared.fetchUser(userId: ride.driverID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.driverName = user.fullName
                case .failure:
                    self.driverName = "Unknown Driver"
                }
            }
        }
    }
}

// Extension to apply corner radius to specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// Custom RoundedCorner shape
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

import SwiftUI

struct RideCardView: View {
    var ride: Ride  // Accepts a Ride object

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(ride.origin) → \(ride.destination)")
                        .font(.headline)
                        .foregroundColor(AppColors.contentText) // Brown text for main info
                    Text("Driver: \(ride.driverName)")
                        .font(.subheadline)
                        .foregroundColor(AppColors.contentText.opacity(0.7)) // Slightly subdued brown
                }
                Spacer()
                Text(ride.price)
                    .font(.headline)
                    .foregroundColor(AppColors.buttonText) // White text for price label
                    .padding(8)
                    .background(AppColors.buttonBackground) // Orange background for price label
                    .cornerRadius(10)
            }
            .padding()
            .background(AppColors.background) // Cream card background
            .cornerRadius(12)
            .shadow(radius: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.buttonBackground, lineWidth: 1) // Orange border for differentiation
            )
        }
        .padding(.horizontal)
    }
}

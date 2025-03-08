import SwiftUI

struct RideCardView: View {
    var ride: Ride
    @State private var driverName: String = "Loading..." // Placeholder while fetching

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(ride.origin) → \(ride.destination)")
                        .font(.headline)
                        .foregroundColor(AppColors.contentText)

                    Text("Driver: \(driverName)")  // 🔄 Use fetched name
                        .font(.subheadline)
                        .foregroundColor(AppColors.contentText.opacity(0.7))
                }
                Spacer()
                Text("\(ride.price)")
                    .font(.headline)
                    .foregroundColor(AppColors.buttonText)
                    .padding(8)
                    .background(AppColors.buttonBackground)
                    .cornerRadius(10)
            }
            .padding()
            .background(AppColors.background)
            .cornerRadius(12)
            .shadow(radius: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.buttonBackground, lineWidth: 1)
            )
        }
        .padding(.horizontal)
        .onAppear {
            fetchDriverName()
        }
    }

    private func fetchDriverName() {
        FirestoreService.shared.fetchUser(userId: ride.driverID) { result in
            switch result {
            case .success(let user):
                self.driverName = user.fullName
            case .failure:
                self.driverName = "Unknown Driver"
            }
        }
    }
}

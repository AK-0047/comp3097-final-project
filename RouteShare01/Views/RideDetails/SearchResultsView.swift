import SwiftUI

struct SearchResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var rides: [Ride] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var searchQuery: String
    var origin: String
    var destination: String
    var date: Date

    var body: some View {
        ZStack {
            AppColors.background.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // **Header**
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
                    
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 40, height: 40)
                }
                .padding(.horizontal, 16)

                // **Loading & Error Handling**
                if isLoading {
                    ProgressView("Loading Rides...")
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if rides.isEmpty {
                    Text("No rides found for this route.")
                        .foregroundColor(AppColors.contentText.opacity(0.7))
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(rides) { ride in
                                RideCardView(ride: ride)
                            }
                        }
                        .padding(.top, 10)
                    }
                }
            }
        }
        .onAppear {
            fetchRides()
        }
    }

    private func fetchRides() {
        FirestoreService.shared.fetchRidesMatching(origin: origin, destination: destination, date: date) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedRides):
                    self.rides = fetchedRides
                case .failure(let error):
                    self.errorMessage = "Error fetching rides: \(error.localizedDescription)"
                }
                self.isLoading = false
            }
        }
    }
}

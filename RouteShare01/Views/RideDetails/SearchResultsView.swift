import SwiftUI

struct SearchResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    var searchQuery: String

    let sampleRides: [Ride] = [
        Ride(id: "1", origin: "Windsor", destination: "Guelph", price: "$25", driverName: "John Doe"),
        Ride(id: "2", origin: "Ottawa", destination: "Montreal", price: "$40", driverName: "Emily Smith"),
        Ride(id: "3", origin: "Toronto", destination: "Kitchner", price: "$35", driverName: "Alex Brown")
    ]

    var body: some View {
        VStack {
            // Back Button and Title Bar
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(AppColors.contentText)
                        .font(.system(size: 20, weight: .bold))
                }
                Spacer()
                Text("Search Results")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.contentText)
                Spacer()
                // Invisible button for spacing consistency
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .opacity(0)
                }
            }
            .padding()

            // Results List
            ScrollView {
                ForEach(sampleRides) { ride in
                    RideCardView(ride: ride)
                        .padding(.horizontal)
                }
            }
        }
        .padding(.top, 10)
        .background(AppColors.background.edgesIgnoringSafeArea(.all))
    }
}

import SwiftUI

struct SearchView: View {
    @State private var origin: String = ""
    @State private var destination: String = ""
    @State private var date: Date = Date()
    @State private var showingSearchResults = false  // Controls navigation
    @State private var searchQuery: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("Find a Ride")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.contentText)
                    .padding(.top, 20)

                // Origin Input Field
                CustomTextField(icon: "location.fill", placeholder: "Enter origin", text: $origin)

                // Destination Input Field
                CustomTextField(icon: "mappin.and.ellipse", placeholder: "Enter destination", text: $destination)

                // Date Picker
                DatePicker("Select Date", selection: $date, displayedComponents: .date)
                    .padding()
                    .background(AppColors.background)
                    .foregroundColor(AppColors.contentText)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppColors.contentText, lineWidth: 1)
                    )
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .padding(.horizontal)

                // Search Button
                Button(action: {
                    searchQuery = "\(origin) to \(destination)"
                    showingSearchResults = true  // Triggers navigation
                }) {
                    Text("Search")
                        .font(.headline)
                        .foregroundColor(AppColors.buttonText)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColors.buttonBackground)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.top, 20)

                Spacer()
            }
            .padding()
            .background(AppColors.background.edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showingSearchResults) {
                SearchResultsView(searchQuery: searchQuery)  // ✅ Corrected Navigation
            }
        }
    }
}

import SwiftUI

struct SearchView: View {
    @State private var origin: String = ""
    @State private var destination: String = ""
    @State private var date: Date = Date()
    @State private var showingSearchResults = false  // Controls navigation
    @State private var searchQuery: String = ""
    @State private var showDatePicker = false  // Controls Date Picker modal
    
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
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(AppColors.buttonBackground)
                    
                    Text("Find a Ride")
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
                    // Input Fields
                    VStack(spacing: 12) {
                        CustomTextField(icon: "location.fill", placeholder: "Enter origin", text: $origin)
                            .frame(maxWidth: 0.85 * UIScreen.main.bounds.width)
                        
                        CustomTextField(icon: "mappin.and.ellipse", placeholder: "Enter destination", text: $destination)
                            .frame(maxWidth: 0.85 * UIScreen.main.bounds.width)
                        
                        // Date Picker Button
                        Button(action: {
                            showDatePicker.toggle()
                        }) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(AppColors.contentText)
                                Text(dateFormatter(date))
                                    .foregroundColor(AppColors.contentText)
                            }
                            .padding()
                            .frame(maxWidth: 0.85 * UIScreen.main.bounds.width)
                            .background(AppColors.background)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(AppColors.contentText, lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Search Button
                    Button(action: {
                        searchQuery = "\(origin) to \(destination) on \(dateFormatter(date))"
                        showingSearchResults = true  // Triggers navigation
                    }) {
                        Text("Search")
                            .font(.headline)
                            .foregroundColor(AppColors.buttonText)
                            .padding()
                            .frame(maxWidth: 0.85 * UIScreen.main.bounds.width)
                            .background(AppColors.buttonBackground)
                            .cornerRadius(12)
                            .shadow(radius: 3)
                    }
                    .padding(.top, 20)
                    
                    // Informational Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Plan Your Trip Effectively")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.contentText)
                        
                        InfoRow(icon: "car.fill", text: "Choose your preferred ride options")
                        InfoRow(icon: "clock.fill", text: "Select the best departure time")
                        InfoRow(icon: "map.fill", text: "Explore different route options")
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .background(AppColors.background.edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingSearchResults) {
            SearchResultsView(searchQuery: searchQuery)
        }
        .sheet(isPresented: $showDatePicker) {
            VStack {
                Text("Select a Date")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                
                DatePicker("", selection: $date, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()
                
                Button("Done") {
                    showDatePicker = false
                }
                .padding()
                .frame(maxWidth: 0.85 * UIScreen.main.bounds.width)
                .background(AppColors.buttonBackground)
                .foregroundColor(AppColors.buttonText)
                .cornerRadius(10)
            }
            .background(AppColors.background)
            .cornerRadius(15)
        }
    }
    
    private func dateFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

struct InfoRow: View {
    var icon: String
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(AppColors.buttonBackground)
            Text(text)
                .foregroundColor(AppColors.contentText)
        }
    }
}

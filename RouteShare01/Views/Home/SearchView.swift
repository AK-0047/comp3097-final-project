import SwiftUI

struct SearchView: View {
    @State private var origin: String = ""
    @State private var destination: String = ""
    @State private var date: Date = Date()
    @State private var showingSearchResults = false
    @State private var searchQuery: String = ""
    @State private var showDatePicker = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            // Main background
            AppColors.background
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Creative header with gradient and illustration
                HeaderView(title: "Find Your Ride")
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Main search card
                        VStack(spacing: 16) {
                            // Origin input
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(AppColors.accentColor)
                                    .frame(width: 10, height: 10)
                                
                                Text("FROM")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(AppColors.contentText.opacity(0.6))
                                    .frame(width: 45, alignment: .leading)
                                
                                TextField("Where are you starting from?", text: $origin)
                                    .font(.system(size: 16))
                                    .foregroundColor(AppColors.contentText)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(AppColors.buttonText)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            
                            // Connecting line
                            HStack {
                                Rectangle()
                                    .fill(AppColors.contentText.opacity(0.1))
                                    .frame(width: 1, height: 15)
                                    .padding(.leading, 4.5)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            
                            // Destination input
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(AppColors.buttonBackground)
                                    .frame(width: 10, height: 10)
                                
                                Text("TO")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(AppColors.contentText.opacity(0.6))
                                    .frame(width: 45, alignment: .leading)
                                
                                TextField("Where are you headed?", text: $destination)
                                    .font(.system(size: 16))
                                    .foregroundColor(AppColors.contentText)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(AppColors.buttonText)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            
                            Divider()
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                            
                            // Date selector
                            Button(action: { showDatePicker.toggle() }) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 16))
                                        .foregroundColor(AppColors.buttonBackground)
                                    
                                    Text(dateFormatter(date))
                                        .font(.system(size: 16))
                                        .foregroundColor(AppColors.contentText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12))
                                        .foregroundColor(AppColors.contentText.opacity(0.4))
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .background(AppColors.buttonText)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            }
                        }
                        .padding(16)
                        .background(AppColors.buttonText)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 20)
                        .padding(.top, 5)
                        
                        // Error message
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .font(.footnote)
                                .foregroundColor(.red)
                                .padding(.top, -5)
                                .padding(.horizontal, 20)
                        }
                        
                        // Loading indicator
                        if isLoading {
                            HStack(spacing: 12) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: AppColors.buttonBackground))
                                
                                Text("Searching for rides...")
                                    .font(.subheadline)
                                    .foregroundColor(AppColors.contentText)
                            }
                            .padding()
                        }
                        
                        // Button
                        Button(action: searchRides) {
                            HStack {
                                Spacer()
                                Text("Find Available Rides")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(AppColors.buttonText)
                                
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 16))
                                    .foregroundColor(AppColors.buttonText)
                                Spacer()
                            }
                            .padding(.vertical, 16)
                            .background(
                                origin.isEmpty || destination.isEmpty ?
                                AppColors.buttonBackground.opacity(0.6) :
                                AppColors.buttonBackground
                            )
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                            .padding(.horizontal, 20)
                        }
                        .disabled(origin.isEmpty || destination.isEmpty)
                        
                        // Feature highlights
                        VStack(spacing: 20) {
                            Text("Why choose our ride-sharing?")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.contentText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ForEach(features) { feature in
                                FeatureRow(
                                    icon: feature.icon,
                                    title: feature.title,
                                    description: feature.description
                                )
                            }
                        }
                        .padding(20)
                        .padding(.top, 5)
                    }
                    .padding(.bottom, 80) // Space for tab bar
                }
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingSearchResults) {
            SearchResultsView(searchQuery: searchQuery, origin: origin, destination: destination, date: date)
        }
        .sheet(isPresented: $showDatePicker) {
            VStack(spacing: 0) {
                HStack {
                    Text("Select Travel Date")
                        .font(.headline)
                        .foregroundColor(AppColors.contentText)
                    
                    Spacer()
                    
                    Button(action: { showDatePicker = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(AppColors.contentText.opacity(0.6))
                    }
                }
                .padding()
                .background(AppColors.background)
                
                Divider()
                
                DatePicker("", selection: $date, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()
                    .background(AppColors.background)
                
                Button(action: { showDatePicker = false }) {
                    Text("Confirm")
                        .font(.headline)
                        .foregroundColor(AppColors.buttonText)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.buttonBackground)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                }
                .background(AppColors.background)
            }
            .background(AppColors.background)
            .cornerRadius(16)
        }
    }
    
    private func searchRides() {
        isLoading = true
        errorMessage = nil
        
        FirestoreService.shared.fetchAllRides { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let allRides):
                    let filteredRides = allRides.filter { ride in
                        return ride.origin.lowercased() == origin.lowercased() &&
                        ride.destination.lowercased() == destination.lowercased() &&
                        Calendar.current.isDate(ride.date, inSameDayAs: date)
                    }
                    
                    if filteredRides.isEmpty {
                        errorMessage = "No rides found for this route."
                    } else {
                        searchQuery = "\(origin) to \(destination) on \(dateFormatter(date))"
                        showingSearchResults = true
                    }
                case .failure(let error):
                    errorMessage = "Error fetching rides: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func dateFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d, yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - Subviews

struct HeaderView: View {
    let title: String
    
    var body: some View {
        ZStack(alignment: .top) {
            // Background gradient that fades to transparent
            LinearGradient(
                gradient: Gradient(colors: [
                    AppColors.buttonBackground.opacity(0.9),
                    AppColors.buttonBackground.opacity(0.7),
                    AppColors.buttonBackground.opacity(0.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 220)
            .clipShape(
                CustomShape(
                    controlPoint1: CGPoint(x: 0.4, y: 1.1),
                    controlPoint2: CGPoint(x: 0.6, y: 0.9)
                )
            )
            
            // Content
            VStack(spacing: 5) {
                // Decorative elements
                HStack {
                    ForEach(0..<3) { i in
                        Image(systemName: "car.fill")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.buttonText.opacity(0.5 + (Double(i) * 0.15)))
                            .offset(y: Double(i) * 2)
                    }
                }
                .padding(.top, 25)
                
                // Main title
                Text(title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppColors.buttonText)
                    .padding(.top, 8)
                
                // Subtitle
                Text("Find and share rides easily")
                    .font(.subheadline)
                    .foregroundColor(AppColors.buttonText.opacity(0.8))
                    .padding(.top, 2)
                    .padding(.bottom, 20)
                
                // Decorative card
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.buttonText.opacity(0.15))
                    .frame(width: 280, height: 20)
                    .overlay(
                        HStack(spacing: 20) {
                            Circle()
                                .fill(AppColors.buttonText)
                                .frame(width: 6, height: 6)
                            Circle()
                                .fill(AppColors.buttonText)
                                .frame(width: 6, height: 6)
                            Circle()
                                .fill(AppColors.buttonText)
                                .frame(width: 6, height: 6)
                        }
                    )
            }
            .padding(.top, 10)
        }
        .frame(height: 180)
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(AppColors.buttonBackground)
                .frame(width: 24, height: 24)
                .padding(12)
                .background(AppColors.buttonBackground.opacity(0.1))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.contentText)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(AppColors.contentText.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
    }
}

// MARK: - Supporting Elements

struct CustomShape: Shape {
    var controlPoint1: CGPoint
    var controlPoint2: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height * 0.75))
        
        // Custom curve
        path.addCurve(
            to: CGPoint(x: 0, y: height * 0.75),
            control1: CGPoint(x: width * controlPoint1.x, y: height * controlPoint1.y),
            control2: CGPoint(x: width * controlPoint2.x, y: height * controlPoint2.y)
        )
        
        path.closeSubpath()
        return path
    }
}

// MARK: - Model

struct Feature: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

// Sample features
let features = [
    Feature(
        icon: "person.2.fill",
        title: "Connect with travelers",
        description: "Share rides with people heading to the same destination and split costs."
    ),
    Feature(
        icon: "leaf.fill",
        title: "Eco-friendly travel",
        description: "Reduce your carbon footprint by sharing vehicles instead of driving alone."
    ),
    Feature(
        icon: "creditcard.fill",
        title: "Save on travel costs",
        description: "Significantly reduce your travel expenses by sharing the ride with others."
    )
]

//import SwiftUI
//
//struct SearchView: View {
//    @State private var origin: String = ""
//    @State private var destination: String = ""
//    @State private var date: Date = Date()
//    @State private var showingSearchResults = false
//    @State private var searchQuery: String = ""
//    @State private var showDatePicker = false
//    @State private var isLoading = false
//    @State private var errorMessage: String?
//
//    var body: some View {
//        ZStack {
//            // Background
//            AppColors.background
//                .edgesIgnoringSafeArea(.all)
//
//            VStack(spacing: 0) {
//                // Fixed header with wave effect
//                ZStack {
//                    // Wave shape background
//                    CurvedShape()
//                        .fill(AppColors.buttonBackground)
//                        .frame(height: 140)
//                        .edgesIgnoringSafeArea(.top)
//
//                    // Title positioned properly
//                    VStack {
//                        Text("Find a Ride")
//                            .font(.system(size: 28, weight: .bold))
//                            .foregroundColor(AppColors.buttonText)
//                            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2) // Added shadow
//                            .padding(.top, 50)
//                    }
//                }
//                .frame(height: 140)
//
//                // Main Content
//                ScrollView {
//                    VStack(spacing: 25) {
//                        // Search fields container
//                        VStack(spacing: 16) {
//                            // Origin field with custom icon
//                            HStack {
//                                ZStack {
//                                    Circle()
//                                        .fill(AppColors.buttonBackground.opacity(0.2))
//                                        .frame(width: 36, height: 36)
//
//                                    Image(systemName: "paperplane.fill")
//                                        .font(.system(size: 16))
//                                        .foregroundColor(AppColors.buttonBackground)
//                                }
//                                .padding(.leading, 12)
//
//                                TextField("Where from?", text: $origin)
//                                    .font(.system(size: 17))
//                                    .foregroundColor(AppColors.contentText)
//                                    .padding(.vertical, 15)
//                                    .padding(.leading, 8)
//                            }
//                            .background(AppColors.buttonText)
//                            .cornerRadius(20)
//                            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
//                            .padding(.horizontal, 20)
//
//                            // Destination field with custom icon
//                            HStack {
//                                ZStack {
//                                    Circle()
//                                        .fill(AppColors.buttonBackground.opacity(0.2))
//                                        .frame(width: 36, height: 36)
//
//                                    Image(systemName: "mappin.circle.fill")
//                                        .font(.system(size: 16))
//                                        .foregroundColor(AppColors.buttonBackground)
//                                }
//                                .padding(.leading, 12)
//
//                                TextField("Where to?", text: $destination)
//                                    .font(.system(size: 17))
//                                    .foregroundColor(AppColors.contentText)
//                                    .padding(.vertical, 15)
//                                    .padding(.leading, 8)
//                            }
//                            .background(AppColors.buttonText)
//                            .cornerRadius(20)
//                            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
//                            .padding(.horizontal, 20)
//
//                            // Date picker button with improved design
//                            Button(action: {
//                                showDatePicker.toggle()
//                            }) {
//                                HStack {
//                                    ZStack {
//                                        Circle()
//                                            .fill(AppColors.buttonBackground.opacity(0.2))
//                                            .frame(width: 36, height: 36)
//
//                                        Image(systemName: "calendar")
//                                            .font(.system(size: 16))
//                                            .foregroundColor(AppColors.buttonBackground)
//                                    }
//                                    .padding(.leading, 12)
//
//                                    Text(dateFormatter(date))
//                                        .font(.system(size: 17))
//                                        .foregroundColor(AppColors.contentText)
//                                        .padding(.vertical, 15)
//                                        .padding(.leading, 8)
//
//                                    Spacer()
//
//                                    Image(systemName: "chevron.down")
//                                        .foregroundColor(AppColors.contentText.opacity(0.6))
//                                        .padding(.trailing, 12)
//                                }
//                                .background(AppColors.buttonText)
//                                .cornerRadius(20)
//                                .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
//                                .padding(.horizontal, 20)
//                            }
//                        }
//                        .padding(.top, 10)
//
//                        if let errorMessage = errorMessage {
//                            Text(errorMessage)
//                                .foregroundColor(.red)
//                                .font(.footnote)
//                                .padding(.top, 5)
//                        }
//
//                        if isLoading {
//                            ProgressView("Searching for rides...")
//                                .foregroundColor(AppColors.contentText)
//                                .padding()
//                        }
//
//                        // Search button with arrow icon
//                        Button(action: searchRides) {
//                            HStack {
//                                Text("Search Rides")
//                                    .font(.headline)
//                                    .fontWeight(.bold)
//                                    .foregroundColor(AppColors.buttonText)
//
//                                Image(systemName: "arrow.right")
//                                    .font(.system(size: 16, weight: .bold))
//                                    .foregroundColor(AppColors.buttonText)
//                                    .padding(.leading, 4)
//                            }
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(AppColors.buttonBackground)
//                            .cornerRadius(25)
//                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
//                            .padding(.horizontal, 20)
//                        }
//                        .disabled(origin.isEmpty || destination.isEmpty)
//                        .opacity(origin.isEmpty || destination.isEmpty ? 0.6 : 1.0)
//                        .padding(.top, 10)
//
//                        // Informational section in card style
//                        VStack(alignment: .leading, spacing: 15) {
//                            Text("Plan Your Trip Effectively")
//                                .font(.title2)
//                                .fontWeight(.bold)
//                                .foregroundColor(AppColors.contentText)
//                                .padding(.horizontal)
//                                .padding(.top, 15)
//
//                            Divider()
//                                .background(AppColors.contentText.opacity(0.2))
//                                .padding(.horizontal)
//
//                            // Info rows with matching icons from the screenshot
//                            HStack(spacing: 15) {
//                                ZStack {
//                                    Circle()
//                                        .fill(AppColors.buttonBackground.opacity(0.2))
//                                        .frame(width: 40, height: 40)
//
//                                    Image(systemName: "car.fill")
//                                        .foregroundColor(AppColors.buttonBackground)
//                                }
//
//                                Text("Choose your preferred ride options")
//                                    .foregroundColor(AppColors.contentText)
//                                    .font(.system(size: 16))
//
//                                Spacer()
//                            }
//                            .padding(.horizontal)
//
//                            HStack(spacing: 15) {
//                                ZStack {
//                                    Circle()
//                                        .fill(AppColors.buttonBackground.opacity(0.2))
//                                        .frame(width: 40, height: 40)
//
//                                    Image(systemName: "clock.fill")
//                                        .foregroundColor(AppColors.buttonBackground)
//                                }
//
//                                Text("Select the best departure time")
//                                    .foregroundColor(AppColors.contentText)
//                                    .font(.system(size: 16))
//
//                                Spacer()
//                            }
//                            .padding(.horizontal)
//
//                            HStack(spacing: 15) {
//                                ZStack {
//                                    Circle()
//                                        .fill(AppColors.buttonBackground.opacity(0.2))
//                                        .frame(width: 40, height: 40)
//
//                                    Image(systemName: "map.fill")
//                                        .foregroundColor(AppColors.buttonBackground)
//                                }
//
//                                Text("Explore different route options")
//                                    .foregroundColor(AppColors.contentText)
//                                    .font(.system(size: 16))
//
//                                Spacer()
//                            }
//                            .padding(.horizontal)
//                            .padding(.bottom, 15)
//                        }
//                        .background(AppColors.buttonText)
//                        .cornerRadius(20)
//                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
//                        .padding(.horizontal, 20)
//                        .padding(.top, 20)
//                    }
//                    .padding(.bottom, 80) // Add padding for tab bar
//                }
//                .background(AppColors.background)
//            }
//
//            // Tab bar at bottom can be rendered by parent view
//        }
//        .navigationBarHidden(true)
//        .fullScreenCover(isPresented: $showingSearchResults) {
//            SearchResultsView(searchQuery: searchQuery, origin: origin, destination: destination, date: date)
//        }
//        .sheet(isPresented: $showDatePicker) {
//            VStack {
//                Text("Select a Date")
//                    .font(.title2)
//                    .fontWeight(.semibold)
//                    .foregroundColor(AppColors.contentText)
//                    .padding()
//
//                DatePicker("", selection: $date, displayedComponents: .date)
//                    .labelsHidden()
//                    .datePickerStyle(WheelDatePickerStyle())
//                    .padding()
//
//                Button("Done") {
//                    showDatePicker = false
//                }
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(AppColors.buttonBackground)
//                .foregroundColor(AppColors.buttonText)
//                .cornerRadius(25)
//                .padding(.horizontal)
//            }
//            .padding(.bottom)
//            .background(AppColors.background)
//            .cornerRadius(15)
//        }
//    }
//
//    private func searchRides() {
//        isLoading = true
//        errorMessage = nil
//
//        FirestoreService.shared.fetchAllRides { result in
//            DispatchQueue.main.async {
//                isLoading = false
//                switch result {
//                case .success(let allRides):
//                    let filteredRides = allRides.filter { ride in
//                        return ride.origin.lowercased() == origin.lowercased() &&
//                               ride.destination.lowercased() == destination.lowercased() &&
//                               Calendar.current.isDate(ride.date, inSameDayAs: date)
//                    }
//
//                    if filteredRides.isEmpty {
//                        errorMessage = "No rides found for this route."
//                    } else {
//                        searchQuery = "\(origin) to \(destination) on \(dateFormatter(date))"
//                        showingSearchResults = true
//                    }
//                case .failure(let error):
//                    errorMessage = "Error fetching rides: \(error.localizedDescription)"
//                }
//            }
//        }
//    }
//
//    private func dateFormatter(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMM d, yyyy"
//        return formatter.string(from: date)
//    }
//}
//
//// Custom curved shape for the wave effect in the header
//struct CurvedShape: Shape {
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        let width = rect.width
//        let height = rect.height
//
//        path.move(to: CGPoint(x: 0, y: 0))
//        path.addLine(to: CGPoint(x: width, y: 0))
//        path.addLine(to: CGPoint(x: width, y: height * 0.75))
//
//        // Adjusted control points for a softer curve
//        path.addCurve(
//            to: CGPoint(x: 0, y: height * 0.75),
//            control1: CGPoint(x: width * 0.8, y: height * 1.1),
//            control2: CGPoint(x: width * 0.2, y: height * 0.6)
//        )
//
//        path.closeSubpath()
//        return path
//    }
//}

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
            // Background
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with fixed height
                HeaderView()
                    .frame(height: 220)
                
                // Main content
                ScrollView {
                    VStack(spacing: 25) {
                        // Search card
                        SearchCard(
                            origin: $origin,
                            destination: $destination,
                            date: $date,
                            showDatePicker: $showDatePicker,
                            isLoading: $isLoading,
                            errorMessage: $errorMessage,
                            searchRides: searchRides,
                            dateFormatter: dateFormatter
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, -60) // Overlap with header
                        
                        // Rideshare Benefits section
                        VStack(alignment: .leading, spacing: 20) {
                            // Section title
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(AppColors.buttonBackground.opacity(0.2))
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: "sparkles")
                                        .foregroundColor(AppColors.buttonBackground)
                                }
                                
                                Text("Rideshare Benefits")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(AppColors.contentText)
                            }
                            .padding(.leading, 20)
                            .padding(.top, 10)
                            
                            // Benefit cards
                            BenefitCard(
                                icon: "dollarsign.circle.fill",
                                title: "Save on Travel Costs",
                                description: "Split expenses with other riders and reduce your commuting costs",
                                color: Color(hex: "#FFA500")
                            )
                            
                            BenefitCard(
                                icon: "leaf.fill",
                                title: "Eco-Friendly Travel",
                                description: "Reduce your carbon footprint by sharing rides with others",
                                color: Color(hex: "#4CAF50")
                            )
                            
                            BenefitCard(
                                icon: "person.2.fill",
                                title: "Meet New People",
                                description: "Connect with others going your way and expand your network",
                                color: Color(hex: "#2196F3")
                            )
                            
                            // Popular Routes section
                            HStack {
                                Text("Popular Routes")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(AppColors.contentText)
                                
                                Spacer()
                                
                                Text("See All")
                                    .font(.system(size: 16))
                                    .foregroundColor(AppColors.buttonBackground)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 15)
                        }
                        
                        Spacer()
                            .frame(height: 80) // Space for tab bar
                    }
                }
            }
            
            // We're not including the tab bar here as it should be managed by parent view
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingSearchResults) {
            SearchResultsView(searchQuery: searchQuery, origin: origin, destination: destination, date: date)
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(date: $date, showDatePicker: $showDatePicker)
        }
    }
    
    // Helper functions
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
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - Header View
struct HeaderView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            // Orange background
            Rectangle()
                .fill(AppColors.buttonBackground)
                .frame(height: 220)
            
            // Wave overlay
            WaveShape()
                .fill(AppColors.background)
                .frame(height: 80)
                .offset(y: 40)
            
            // Content - Perfect Ride title
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Perfect")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.white)
                            .opacity(0.7)
                        
                        Text("Ride")
                            .font(.system(size: 60, weight: .heavy))
                            .foregroundColor(.white)
                            .offset(y: -10)
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                    
                    // Icon
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "figure.walk")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 30)
                }
                .padding(.top, 60) // Adjust for status bar
                .padding(.bottom, 60) // Position above the wave
            }
        }
    }
}

// MARK: - Wave Shape
struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // Start at top left
        path.move(to: CGPoint(x: 0, y: 0))
        
        // Go to top right
        path.addLine(to: CGPoint(x: width, y: 0))
        
        // Go to bottom right
        path.addLine(to: CGPoint(x: width, y: height))
        
        // Create wave
        path.addCurve(
            to: CGPoint(x: 0, y: height),
            control1: CGPoint(x: width * 0.75, y: height * 0.5),
            control2: CGPoint(x: width * 0.25, y: height * 0.8)
        )
        
        // Close path
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Search Card
struct SearchCard: View {
    @Binding var origin: String
    @Binding var destination: String
    @Binding var date: Date
    @Binding var showDatePicker: Bool
    @Binding var isLoading: Bool
    @Binding var errorMessage: String?
    
    var searchRides: () -> Void
    var dateFormatter: (Date) -> String
    
    var body: some View {
        VStack(spacing: 15) {
            // Input fields
            InputField(
                text: $origin,
                placeholder: "Where from?",
                icon: "arrow.up.circle.fill"
            )
            
            // Route connector
            HStack {
                Circle()
                    .fill(AppColors.buttonBackground)
                    .frame(width: 5, height: 5)
                    .padding(.leading, 36)
                
                Spacer()
            }
            
            InputField(
                text: $destination,
                placeholder: "Where to?",
                icon: "mappin.circle.fill"
            )
            
            // Date picker button
            Button(action: {
                showDatePicker.toggle()
            }) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(AppColors.buttonBackground.opacity(0.2))
                            .frame(width: 36, height: 36)
                        
                        Image(systemName: "calendar")
                            .foregroundColor(AppColors.buttonBackground)
                    }
                    .padding(.leading, 16)
                    
                    Text(dateFormatter(date))
                        .foregroundColor(AppColors.contentText)
                        .font(.system(size: 16))
                        .padding(.leading, 10)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down.circle.fill")
                        .foregroundColor(AppColors.buttonBackground)
                        .padding(.trailing, 16)
                }
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(25)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            }
            
            // Error message if present
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, 5)
            }
            
            // Loading indicator
            if isLoading {
                ProgressView("Searching for rides...")
                    .padding(.vertical, 10)
            }
            
            // Search button
            Button(action: searchRides) {
                HStack {
                    Text("Find Rides")
                        .foregroundColor(.white)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.lightGray)
                .cornerRadius(25)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            .disabled(origin.isEmpty || destination.isEmpty)
            .opacity(origin.isEmpty || destination.isEmpty ? 0.6 : 1.0)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Input Field
struct InputField: View {
    @Binding var text: String
    var placeholder: String
    var icon: String
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(AppColors.buttonBackground.opacity(0.2))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .foregroundColor(AppColors.buttonBackground)
            }
            .padding(.leading, 16)
            
            TextField(placeholder, text: $text)
                .padding(.leading, 10)
                .foregroundColor(AppColors.contentText)
            
            Spacer()
        }
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Benefit Card
struct BenefitCard: View {
    var icon: String
    var title: String
    var description: String
    var color: Color
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(color)
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
            
            // Text content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppColors.contentText)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(Color.gray)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 20)
    }
}

// MARK: - Date Picker Sheet
struct DatePickerSheet: View {
    @Binding var date: Date
    @Binding var showDatePicker: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Handle indicator
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
            
            Text("Select a Date")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.contentText)
                .padding()
            
            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            
            Button("Done") {
                showDatePicker = false
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(AppColors.buttonBackground)
            .foregroundColor(.white)
            .cornerRadius(25)
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .background(AppColors.background)
        .cornerRadius(20)
    }
}

// MARK: - Light Gray Color Extension
extension Color {
    static let lightGray = Color(UIColor.lightGray)
}

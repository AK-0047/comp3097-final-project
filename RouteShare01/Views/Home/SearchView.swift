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
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [AppColors.background.opacity(0.9), AppColors.background]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Hero header with animated wave effect
                ZStack {
                    // Layered wave shapes for depth
                    WaveShape(amplitude: 40, frequency: 0.9)
                        .fill(AppColors.buttonBackground.opacity(0.7))
                        .frame(height: 160)
                        .edgesIgnoringSafeArea(.top)
                    
                    WaveShape(amplitude: 30, frequency: 1.1)
                        .fill(AppColors.buttonBackground)
                        .frame(height: 150)
                        .edgesIgnoringSafeArea(.top)
                    
                    // Header content
                    VStack(spacing: 12) {
                        Text("Find a Ride")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(AppColors.buttonText)
                            .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 2)
                        
                        Text("Where would you like to go today?")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.buttonText.opacity(0.85))
                    }
                    .padding(.top, 50)
                }
                .frame(height: 160)
                
                // Main Content in a card
                VStack {
                    ScrollView {
                        VStack(spacing: 25) {
                            // Search card
                            VStack(spacing: 20) {
                                // Origin-Destination connector visual
                                HStack(alignment: .top, spacing: 15) {
                                    // Vertical connectors
                                    VStack(spacing: 0) {
                                        Circle()
                                            .fill(AppColors.buttonBackground)
                                            .frame(width: 14, height: 14)
                                        
                                        Rectangle()
                                            .fill(AppColors.buttonBackground.opacity(0.5))
                                            .frame(width: 2, height: 42)
                                        
                                        Circle()
                                            .fill(AppColors.buttonBackground)
                                            .frame(width: 14, height: 14)
                                    }
                                    .padding(.top, 12)
                                    .padding(.leading, 20)
                                    
                                    // Fields
                                    VStack(spacing: 18) {
                                        // Origin field
                                        TextField("Where from?", text: $origin)
                                            .font(.system(size: 17))
                                            .foregroundColor(AppColors.contentText)
                                            .padding(.vertical, 15)
                                            .padding(.horizontal, 20)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(AppColors.buttonText)
                                                    .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
                                            )
                                        
                                        // Destination field
                                        TextField("Where to?", text: $destination)
                                            .font(.system(size: 17))
                                            .foregroundColor(AppColors.contentText)
                                            .padding(.vertical, 15)
                                            .padding(.horizontal, 20)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(AppColors.buttonText)
                                                    .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
                                            )
                                    }
                                    .padding(.trailing, 20)
                                }
                                
                                // Date selection button with enhanced design
                                Button(action: {
                                    showDatePicker.toggle()
                                }) {
                                    HStack {
                                        Image(systemName: "calendar")
                                            .font(.system(size: 18))
                                            .foregroundColor(AppColors.buttonBackground)
                                            .padding(.leading, 20)
                                        
                                        Text(dateFormatter(date))
                                            .font(.system(size: 17))
                                            .foregroundColor(AppColors.contentText)
                                            .padding(.vertical, 15)
                                            .padding(.leading, 10)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(AppColors.buttonBackground)
                                            .padding(.trailing, 20)
                                    }
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.buttonText)
                                            .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
                                    )
                                    .padding(.horizontal, 20)
                                }
                                
                                if let errorMessage = errorMessage {
                                    Text(errorMessage)
                                        .foregroundColor(.red)
                                        .font(.system(size: 14))
                                        .padding(.top, 5)
                                        .padding(.horizontal, 20)
                                }
                                
                                if isLoading {
                                    HStack(spacing: 10) {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: AppColors.buttonBackground))
                                        Text("Searching for rides...")
                                            .foregroundColor(AppColors.contentText)
                                            .font(.system(size: 15))
                                    }
                                    .padding()
                                }
                                
                                // Search button with gradient and animation
                                Button(action: searchRides) {
                                    HStack {
                                        Text("Find My Ride")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(AppColors.buttonText)
                                        
                                        Image(systemName: "magnifyingglass")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(AppColors.buttonText)
                                            .padding(.leading, 4)
                                    }
                                    .padding(.vertical, 18)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [AppColors.buttonBackground, AppColors.buttonBackground.opacity(0.8)]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(18)
                                    .shadow(color: AppColors.buttonBackground.opacity(0.4), radius: 8, x: 0, y: 4)
                                    .padding(.horizontal, 20)
                                    .padding(.top, 5)
                                }
                                .disabled(origin.isEmpty || destination.isEmpty)
                                .opacity(origin.isEmpty || destination.isEmpty ? 0.6 : 1.0)
                                .padding(.bottom, 10)
                            }
                            .padding(.vertical, 25)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(AppColors.background.opacity(0.5))
                                    .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 5)
                            )
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                            
                            // Ride options showcase with cards
                            VStack(alignment: .leading, spacing: 20) {
                                // Section title
                                Text("Travel Options")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(AppColors.contentText)
                                    .padding(.horizontal, 20)
                                
                                // Option cards in horizontal scroll
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        // Option 1
                                        VStack(alignment: .leading, spacing: 12) {
                                            ZStack {
                                                Circle()
                                                    .fill(AppColors.buttonBackground.opacity(0.2))
                                                    .frame(width: 50, height: 50)
                                                
                                                Image(systemName: "car.fill")
                                                    .font(.system(size: 22))
                                                    .foregroundColor(AppColors.buttonBackground)
                                            }
                                            
                                            Text("Choose Ride")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(AppColors.contentText)
                                            
                                            Text("Select your preferred ride options")
                                                .font(.system(size: 14))
                                                .foregroundColor(AppColors.contentText.opacity(0.7))
                                                .multilineTextAlignment(.leading)
                                        }
                                        .padding(.vertical, 20)
                                        .padding(.horizontal, 20)
                                        .frame(width: 180)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(AppColors.buttonText)
                                                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                                        )
                                        
                                        // Option 2
                                        VStack(alignment: .leading, spacing: 12) {
                                            ZStack {
                                                Circle()
                                                    .fill(AppColors.buttonBackground.opacity(0.2))
                                                    .frame(width: 50, height: 50)
                                                
                                                Image(systemName: "clock.fill")
                                                    .font(.system(size: 22))
                                                    .foregroundColor(AppColors.buttonBackground)
                                            }
                                            
                                            Text("Best Time")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(AppColors.contentText)
                                            
                                            Text("Select the best departure time")
                                                .font(.system(size: 14))
                                                .foregroundColor(AppColors.contentText.opacity(0.7))
                                                .multilineTextAlignment(.leading)
                                        }
                                        .padding(.vertical, 20)
                                        .padding(.horizontal, 20)
                                        .frame(width: 180)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(AppColors.buttonText)
                                                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                                        )
                                        
                                        // Option 3
                                        VStack(alignment: .leading, spacing: 12) {
                                            ZStack {
                                                Circle()
                                                    .fill(AppColors.buttonBackground.opacity(0.2))
                                                    .frame(width: 50, height: 50)
                                                
                                                Image(systemName: "map.fill")
                                                    .font(.system(size: 22))
                                                    .foregroundColor(AppColors.buttonBackground)
                                            }
                                            
                                            Text("Route Options")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(AppColors.contentText)
                                            
                                            Text("Explore different route options")
                                                .font(.system(size: 14))
                                                .foregroundColor(AppColors.contentText.opacity(0.7))
                                                .multilineTextAlignment(.leading)
                                        }
                                        .padding(.vertical, 20)
                                        .padding(.horizontal, 20)
                                        .frame(width: 180)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(AppColors.buttonText)
                                                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                                        )
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                            .padding(.top, 10)
                            .padding(.bottom, 80) // Add padding for tab bar
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingSearchResults) {
            SearchResultsView(searchQuery: searchQuery, origin: origin, destination: destination, date: date)
        }
        .sheet(isPresented: $showDatePicker) {
            // Modern date picker sheet
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("Select Travel Date")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(AppColors.contentText)
                    
                    Spacer()
                    
                    Button(action: {
                        showDatePicker = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppColors.contentText.opacity(0.6))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Date Picker
                DatePicker("", selection: $date, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding(.horizontal, 20)
                
                // Confirm button
                Button(action: {
                    showDatePicker = false
                }) {
                    Text("Confirm Date")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.buttonText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [AppColors.buttonBackground, AppColors.buttonBackground.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: AppColors.buttonBackground.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .background(AppColors.background)
            .cornerRadius(25)
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
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

// Enhanced wave shape for more fluid appearance
struct WaveShape: Shape {
    var amplitude: CGFloat
    var frequency: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let midHeight = height * 0.8
        let wavesHeight = height * 0.2
        
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: midHeight))
        
        // Create a more natural wave pattern
        var x: CGFloat = 0
        let waveSegments = 5
        let dx = width / CGFloat(waveSegments)
        
        path.move(to: CGPoint(x: width, y: midHeight))
        
        for i in 0...waveSegments {
            x = width - CGFloat(i) * dx
            let y = midHeight + sin(CGFloat(i) * frequency) * amplitude
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                let prevX = width - CGFloat(i-1) * dx
                let prevY = midHeight + sin(CGFloat(i-1) * frequency) * amplitude
                
                let controlX1 = prevX - dx * 0.4
                let controlY1 = prevY
                let controlX2 = x + dx * 0.4
                let controlY2 = y
                
                path.addCurve(
                    to: CGPoint(x: x, y: y),
                    control1: CGPoint(x: controlX1, y: controlY1),
                    control2: CGPoint(x: controlX2, y: controlY2)
                )
            }
        }
        
        path.addLine(to: CGPoint(x: 0, y: midHeight))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        return path
    }
}

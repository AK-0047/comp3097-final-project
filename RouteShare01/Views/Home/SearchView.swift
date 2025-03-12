//import SwiftUI
//
//struct SearchView: View {
//    @State private var origin: String = ""
//    @State private var destination: String = ""
//    @State private var date: Date = Date()
//    @State private var showingSearchResults = false  // Controls navigation
//    @State private var searchQuery: String = ""
//    @State private var showDatePicker = false  // Controls Date Picker modal
//    @State private var isLoading = false
//    @State private var errorMessage: String?
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            // **Fixed Header Without Layering**
//            VStack {
//                HStack(spacing: 8) {
//                    Image(systemName: "magnifyingglass")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 30, height: 30)
//                        .foregroundColor(AppColors.buttonBackground)
//                    
//                    Text("Find a Ride")
//                        .font(.title)
//                        .fontWeight(.bold)
//                        .foregroundColor(AppColors.contentText)
//                }
//                .padding(.top, 20)
//                .padding(.bottom, 10)
//            }
//            .frame(maxWidth: .infinity)
//            .background(AppColors.background)  // Ensures same background color to remove layering
//            .zIndex(1)
//            
//            // **Scrollable Content**
//            ScrollView {
//                VStack(spacing: 20) {
//                    // **Input Fields**
//                    VStack(spacing: 12) {
//                        CustomTextField(icon: "location.fill", placeholder: "Enter origin", text: $origin)
//                            .frame(maxWidth: 0.85 * UIScreen.main.bounds.width)
//                        
//                        CustomTextField(icon: "mappin.and.ellipse", placeholder: "Enter destination", text: $destination)
//                            .frame(maxWidth: 0.85 * UIScreen.main.bounds.width)
//                        
//                        // **Date Picker Button**
//                        Button(action: {
//                            showDatePicker.toggle()
//                        }) {
//                            HStack {
//                                Image(systemName: "calendar")
//                                    .foregroundColor(AppColors.contentText)
//                                Text(dateFormatter(date))
//                                    .foregroundColor(AppColors.contentText)
//                                Spacer()
//                            }
//                            .padding()
//                            .frame(maxWidth: 0.85 * UIScreen.main.bounds.width)
//                            .background(AppColors.background)
//                            .cornerRadius(10)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(AppColors.contentText, lineWidth: 1)
//                            )
//                        }
//                    }
//                    
//                    if let errorMessage = errorMessage {
//                        Text(errorMessage)
//                            .foregroundColor(.red)
//                            .font(.footnote)
//                            .padding(.top, 5)
//                    }
//
//                    if isLoading {
//                        ProgressView("Searching for rides...")
//                            .padding()
//                    }
//                    
//                    // **Search Button**
//                    Button(action: searchRides) {
//                        Text("Search")
//                            .font(.headline)
//                            .foregroundColor(AppColors.buttonText)
//                            .padding()
//                            .frame(maxWidth: 0.85 * UIScreen.main.bounds.width)
//                            .background(AppColors.buttonBackground)
//                            .cornerRadius(12)
//                            .shadow(radius: 3)
//                    }
//                    .padding(.top, 20)
//                    .disabled(origin.isEmpty || destination.isEmpty)
//                    .opacity(origin.isEmpty || destination.isEmpty ? 0.6 : 1.0)
//                    
//                    // **Informational Section**
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text("Plan Your Trip Effectively")
//                            .font(.title2)
//                            .fontWeight(.semibold)
//                            .foregroundColor(AppColors.contentText)
//                        
//                        InfoRow(icon: "car.fill", text: "Choose your preferred ride options")
//                        InfoRow(icon: "clock.fill", text: "Select the best departure time")
//                        InfoRow(icon: "map.fill", text: "Explore different route options")
//                    }
//                    .padding(.horizontal)
//                }
//                .padding(.vertical)
//                .background(AppColors.background)  // Ensure same background color
//            }
//        }
//        .background(AppColors.background.edgesIgnoringSafeArea(.all))  // Fix for safe area
//        .navigationBarHidden(true)
//        .fullScreenCover(isPresented: $showingSearchResults) {
//            SearchResultsView(searchQuery: searchQuery, origin: origin, destination: destination, date: date)
//        }
//        .sheet(isPresented: $showDatePicker) {
//            VStack {
//                Text("Select a Date")
//                    .font(.title2)
//                    .fontWeight(.semibold)
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
//                .frame(maxWidth: 0.85 * UIScreen.main.bounds.width)
//                .background(AppColors.buttonBackground)
//                .foregroundColor(AppColors.buttonText)
//                .cornerRadius(10)
//            }
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
//                    // **✅ Filter Rides Based on User Input**
//                    let filteredRides = allRides.filter { ride in
//                        return ride.origin.lowercased() == origin.lowercased() &&
//                               ride.destination.lowercased() == destination.lowercased() &&
//                               Calendar.current.isDate(ride.date, inSameDayAs: date)  // ✅ Compare only Date
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
//
//    private func dateFormatter(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMM d, yyyy"
//        return formatter.string(from: date)
//    }
//}
//
//// **Reusable InfoRow Component**
//struct InfoRow: View {
//    var icon: String
//    var text: String
//    
//    var body: some View {
//        HStack {
//            Image(systemName: icon)
//                .foregroundColor(AppColors.buttonBackground)
//            Text(text)
//                .foregroundColor(AppColors.contentText)
//        }
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
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Fixed header with wave effect
                ZStack {
                    // Wave shape background
                    CurvedShape()
                        .fill(AppColors.buttonBackground)
                        .frame(height: 140)
                        .edgesIgnoringSafeArea(.top)
                    
                    // Title positioned properly
                    VStack {
                        Text("Find a Ride")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(AppColors.buttonText)
                            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2) // Added shadow
                            .padding(.top, 50)
                    }
                }
                .frame(height: 140)
                
                // Main Content
                ScrollView {
                    VStack(spacing: 25) {
                        // Search fields container
                        VStack(spacing: 16) {
                            // Origin field with custom icon
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(AppColors.buttonBackground.opacity(0.2))
                                        .frame(width: 36, height: 36)
                                    
                                    Image(systemName: "paperplane.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(AppColors.buttonBackground)
                                }
                                .padding(.leading, 12)
                                
                                TextField("Where from?", text: $origin)
                                    .font(.system(size: 17))
                                    .foregroundColor(AppColors.contentText)
                                    .padding(.vertical, 15)
                                    .padding(.leading, 8)
                            }
                            .background(AppColors.buttonText)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                            .padding(.horizontal, 20)
                            
                            // Destination field with custom icon
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(AppColors.buttonBackground.opacity(0.2))
                                        .frame(width: 36, height: 36)
                                    
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(AppColors.buttonBackground)
                                }
                                .padding(.leading, 12)
                                
                                TextField("Where to?", text: $destination)
                                    .font(.system(size: 17))
                                    .foregroundColor(AppColors.contentText)
                                    .padding(.vertical, 15)
                                    .padding(.leading, 8)
                            }
                            .background(AppColors.buttonText)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                            .padding(.horizontal, 20)
                            
                            // Date picker button with improved design
                            Button(action: {
                                showDatePicker.toggle()
                            }) {
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(AppColors.buttonBackground.opacity(0.2))
                                            .frame(width: 36, height: 36)
                                        
                                        Image(systemName: "calendar")
                                            .font(.system(size: 16))
                                            .foregroundColor(AppColors.buttonBackground)
                                    }
                                    .padding(.leading, 12)
                                    
                                    Text(dateFormatter(date))
                                        .font(.system(size: 17))
                                        .foregroundColor(AppColors.contentText)
                                        .padding(.vertical, 15)
                                        .padding(.leading, 8)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(AppColors.contentText.opacity(0.6))
                                        .padding(.trailing, 12)
                                }
                                .background(AppColors.buttonText)
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.top, 10)
                        
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding(.top, 5)
                        }
                        
                        if isLoading {
                            ProgressView("Searching for rides...")
                                .foregroundColor(AppColors.contentText)
                                .padding()
                        }
                        
                        // Search button with arrow icon
                        Button(action: searchRides) {
                            HStack {
                                Text("Search Rides")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppColors.buttonText)
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(AppColors.buttonText)
                                    .padding(.leading, 4)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(AppColors.buttonBackground)
                            .cornerRadius(25)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                            .padding(.horizontal, 20)
                        }
                        .disabled(origin.isEmpty || destination.isEmpty)
                        .opacity(origin.isEmpty || destination.isEmpty ? 0.6 : 1.0)
                        .padding(.top, 10)
                        
                        // Informational section in card style
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Plan Your Trip Effectively")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.contentText)
                                .padding(.horizontal)
                                .padding(.top, 15)
                            
                            Divider()
                                .background(AppColors.contentText.opacity(0.2))
                                .padding(.horizontal)
                            
                            // Info rows with matching icons from the screenshot
                            HStack(spacing: 15) {
                                ZStack {
                                    Circle()
                                        .fill(AppColors.buttonBackground.opacity(0.2))
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: "car.fill")
                                        .foregroundColor(AppColors.buttonBackground)
                                }
                                
                                Text("Choose your preferred ride options")
                                    .foregroundColor(AppColors.contentText)
                                    .font(.system(size: 16))
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            HStack(spacing: 15) {
                                ZStack {
                                    Circle()
                                        .fill(AppColors.buttonBackground.opacity(0.2))
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: "clock.fill")
                                        .foregroundColor(AppColors.buttonBackground)
                                }
                                
                                Text("Select the best departure time")
                                    .foregroundColor(AppColors.contentText)
                                    .font(.system(size: 16))
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            HStack(spacing: 15) {
                                ZStack {
                                    Circle()
                                        .fill(AppColors.buttonBackground.opacity(0.2))
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: "map.fill")
                                        .foregroundColor(AppColors.buttonBackground)
                                }
                                
                                Text("Explore different route options")
                                    .foregroundColor(AppColors.contentText)
                                    .font(.system(size: 16))
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 15)
                        }
                        .background(AppColors.buttonText)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                    .padding(.bottom, 80) // Add padding for tab bar
                }
                .background(AppColors.background)
            }
            
            // Tab bar at bottom can be rendered by parent view
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingSearchResults) {
            SearchResultsView(searchQuery: searchQuery, origin: origin, destination: destination, date: date)
        }
        .sheet(isPresented: $showDatePicker) {
            VStack {
                Text("Select a Date")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.contentText)
                    .padding()
                
                DatePicker("", selection: $date, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()
                
                Button("Done") {
                    showDatePicker = false
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(AppColors.buttonBackground)
                .foregroundColor(AppColors.buttonText)
                .cornerRadius(25)
                .padding(.horizontal)
            }
            .padding(.bottom)
            .background(AppColors.background)
            .cornerRadius(15)
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

// Custom curved shape for the wave effect in the header
struct CurvedShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height * 0.75))
        
        // Adjusted control points for a softer curve
        path.addCurve(
            to: CGPoint(x: 0, y: height * 0.75),
            control1: CGPoint(x: width * 0.8, y: height * 1.1),
            control2: CGPoint(x: width * 0.2, y: height * 0.6)
        )
        
        path.closeSubpath()
        return path
    }
}

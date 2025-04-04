//import SwiftUI
//import FirebaseAuth
//import FirebaseFirestore
//
//struct PostRideView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @State private var origin: String = ""
//    @State private var destination: String = ""
//    @State private var date: Date = Date()
//    @State private var price: String = ""
//    @State private var seatsAvailable: String = ""
//    @State private var vehicleModel: String = ""
//    @State private var vehiclePlate: String = ""
//    @State private var driverLicense: String = ""
//    @State private var contactNumber: String = ""
//    @State private var additionalNotes: String = ""
//    
//    @State private var showDatePicker = false
//    @State private var showSuccessDialog = false
//    @State private var errorMessage: String?
//    @State private var navigateToHome = false
//    @State private var isLoading = true
//
//    var body: some View {
//        VStack(spacing: 0) {
//            // **Fixed Header**
//            VStack {
//                HStack(spacing: 8) {
//                    Image(systemName: "car.fill")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 30, height: 30)
//                        .foregroundColor(AppColors.buttonBackground)
//                    
//                    Text("Post a Ride")
//                        .font(.title)
//                        .fontWeight(.bold)
//                        .foregroundColor(AppColors.contentText)
//                }
//                .padding(.top, 20)
//                .padding(.bottom, 10)
//            }
//            .frame(maxWidth: .infinity)
//            .background(AppColors.background)
//            .zIndex(1)
//            
//            // **Loading Indicator**
//            if isLoading {
//                ProgressView("Loading user info...")
//                    .padding(.top, 20)
//            } else {
//                ScrollView {
//                    VStack(spacing: 20) {
//                        // **Trip Details**
//                        SectionTitle(title: "Trip Details")
//                        CustomTextField(icon: "location.fill", placeholder: "Enter origin", text: $origin)
//                        CustomTextField(icon: "mappin.and.ellipse", placeholder: "Enter destination", text: $destination)
//                        
//                        // **Date Picker Button**
//                        Button(action: { showDatePicker.toggle() }) {
//                            HStack {
//                                Image(systemName: "calendar")
//                                    .foregroundColor(AppColors.contentText)
//                                Text(dateFormatter(date))
//                                    .foregroundColor(AppColors.contentText)
//                                Spacer()
//                            }
//                            .padding()
//                            .frame(maxWidth: 0.9 * UIScreen.main.bounds.width)
//                            .background(AppColors.background)
//                            .cornerRadius(10)
//                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.contentText, lineWidth: 1))
//                        }
//                        
//                        CustomTextField(icon: "dollarsign.circle.fill", placeholder: "Enter Price", text: $price)
//                            .keyboardType(.decimalPad)
//                        CustomTextField(icon: "person.2.fill", placeholder: "Available Seats", text: $seatsAvailable)
//                            .keyboardType(.numberPad)
//
//                        // **Vehicle Details**
//                        SectionTitle(title: "Vehicle Details")
//                        CustomTextField(icon: "car.fill", placeholder: "Vehicle Model", text: $vehicleModel)
//                        CustomTextField(icon: "number.circle.fill", placeholder: "License Plate Number", text: $vehiclePlate)
//
//                        // **Driver Verification**
//                        SectionTitle(title: "Driver Verification")
//                        CustomTextField(icon: "doc.text.fill", placeholder: "Driver's License Number", text: $driverLicense)
//                        CustomTextField(icon: "phone.fill", placeholder: "Contact Number", text: $contactNumber)
//                            .keyboardType(.phonePad)
//                        
//                        CustomTextField(icon: "note.text", placeholder: "Additional Notes", text: $additionalNotes)
//                        
//                        // **Post Ride Button**
//                        Button(action: postRide) {
//                            HStack {
//                                Image(systemName: "car.fill")
//                                Text("Post Ride")
//                                    .fontWeight(.bold)
//                            }
//                            .foregroundColor(AppColors.buttonText)
//                            .padding()
//                            .frame(maxWidth: 0.9 * UIScreen.main.bounds.width)
//                            .background(AppColors.buttonBackground)
//                            .cornerRadius(12)
//                        }
//                        .padding(.top, 20)
//                        
//                        if let errorMessage = errorMessage {
//                            Text(errorMessage)
//                                .foregroundColor(.red)
//                                .padding(.top, 5)
//                        }
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.vertical)
//                }
//            }
//            
//            // **Navigation to HomeView**
//            NavigationLink(
//                destination: HomeView(),
//                isActive: $navigateToHome,
//                label: { EmptyView() }
//            )
//        }
//        .background(AppColors.background.edgesIgnoringSafeArea(.all))
//        .navigationBarHidden(true)
//        .alert(isPresented: $showSuccessDialog) {
//            Alert(
//                title: Text("Success!"),
//                message: Text("Your ride has been posted successfully."),
//                dismissButton: .default(Text("OK"), action: {
//                    navigateToHome = true
//                })
//            )
//        }
//        .onAppear {
//            fetchUserData()
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
//                .frame(maxWidth: 0.9 * UIScreen.main.bounds.width)
//                .background(AppColors.buttonBackground)
//                .foregroundColor(AppColors.buttonText)
//                .cornerRadius(10)
//            }
//            .background(AppColors.background)
//            .cornerRadius(15)
//        }
//    }
//    
//    private func dateFormatter(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMM d, yyyy"
//        return formatter.string(from: date)
//    }
//
//    private func fetchUserData() {
//        guard let userId = Auth.auth().currentUser?.uid else {
//            errorMessage = "User not logged in."
//            isLoading = false
//            return
//        }
//
//        FirestoreService.shared.fetchUser(userId: userId) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let user):
//                    self.vehicleModel = user.vehicleModel ?? ""
//                    self.vehiclePlate = user.vehiclePlate ?? ""
//                    self.driverLicense = user.driverLicense ?? ""
//                    self.contactNumber = user.contactNumber
//                case .failure(let error):
//                    self.errorMessage = error.localizedDescription
//                }
//                isLoading = false
//            }
//        }
//    }
//    
//    private func postRide() {
//        guard let userID = Auth.auth().currentUser?.uid,
//              !origin.isEmpty, !destination.isEmpty, !price.isEmpty, !seatsAvailable.isEmpty, !vehicleModel.isEmpty, !vehiclePlate.isEmpty, !driverLicense.isEmpty, !contactNumber.isEmpty else {
//            errorMessage = "Please fill in all required fields."
//            return
//        }
//        
//        let firestoreTimestamp = Timestamp(date: date)
//
//        let newRideData: [String: Any] = [
//                "id": UUID().uuidString,
//                "origin": origin,
//                "destination": destination,
//                "date": firestoreTimestamp,
//                "price": Double(price) ?? 0.0,
//                "seatsAvailable": Int(seatsAvailable) ?? 0,
//                "driverID": userID,
//                "vehicleModel": vehicleModel,
//                "vehiclePlate": vehiclePlate,
//                "driverLicense": driverLicense,
//                "contactNumber": contactNumber,
//                "additionalNotes": additionalNotes
//            ]
//            
//            FirestoreService.shared.addRide(rideData: newRideData) { result in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success:
//                        showSuccessDialog = true
//                    case .failure(let error):
//                        errorMessage = error.localizedDescription
//                    }
//                }
//            }
//    }
//
//}
//
//// **Reusable Section Title**
//struct SectionTitle: View {
//    let title: String
//
//    var body: some View {
//        Text(title)
//            .font(.title2)
//            .fontWeight(.semibold)
//            .foregroundColor(AppColors.contentText)
//            .padding(.horizontal, 20)
//    }
//}


import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// Updated modifiers for PostRideView
struct PostRideCardModifier: ViewModifier {
    var color: Color = .white
    var shadowColor: Color = Color.black.opacity(0.1)
    
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(color)
                    .shadow(color: shadowColor, radius: 12, x: 0, y: 6)
            )
            .padding(.horizontal)
            .padding(.bottom, 18)
    }
}

struct PostRideInputModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
            )
    }
}

struct PostRideButtonModifier: ViewModifier {
    var isMain: Bool = true
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(isMain ? .white : AppColors.buttonBackground)
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                Group {
                    if isMain {
                        ZStack {
                            LinearGradient(
                                gradient: Gradient(colors: [AppColors.buttonBackground, Color(hex: "#FF7800")]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            
                            // Subtle pattern overlay
                            Rectangle()
                                .fill(Color.white.opacity(0.1))
                                .mask(
                                    HStack(spacing: 0) {
                                        ForEach(0..<15) { i in
                                            Rectangle()
                                                .frame(width: 10)
                                                .offset(x: CGFloat(i) * 20)
                                        }
                                    }
                                )
                        }
                    } else {
                        Color.white
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: isMain ? AppColors.buttonBackground.opacity(0.5) : Color.gray.opacity(0.2),
                    radius: isMain ? 10 : 6,
                    x: 0,
                    y: isMain ? 5 : 3)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(isMain ? Color.clear : AppColors.buttonBackground, lineWidth: isMain ? 0 : 1.5)
            )
            .padding(.horizontal)
    }
}

struct PostRideSectionTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(AppColors.contentText)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 12)
    }
}

// New custom components
struct IconWithGlow: View {
    var iconName: String
    var color: Color = AppColors.buttonBackground
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: 48, height: 48)
            
            Circle()
                .fill(color.opacity(0.15))
                .frame(width: 56, height: 56)
            
            Image(systemName: iconName)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(color)
        }
    }
}

struct CustomNumberField: View {
    var icon: String
    var placeholder: String
    var prefix: String?
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(AppColors.buttonBackground)
                .frame(width: 22)
            
            if let prefix = prefix {
                Text(prefix)
                    .foregroundColor(AppColors.contentText)
                    .fontWeight(.medium)
            }
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .foregroundColor(AppColors.contentText)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
    }
}

struct PostRideView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var origin: String = ""
    @State private var destination: String = ""
    @State private var date: Date = Date()
    @State private var price: String = ""
    @State private var seatsAvailable: String = ""
    @State private var vehicleModel: String = ""
    @State private var vehiclePlate: String = ""
    @State private var driverLicense: String = ""
    @State private var contactNumber: String = ""
    @State private var additionalNotes: String = ""
    
    @State private var showDatePicker = false
    @State private var showSuccessDialog = false
    @State private var errorMessage: String?
    @State private var navigateToHome = false
    @State private var isLoading = true
    
    // Animation states
    @State private var showingCards = false
    @State private var currentStep = 1
    @State private var animateButton = false
    @State private var animatingBackground = false
    
    // Form validation
    @State private var isValid = false
    
    // Colors for cards
    let cardColors = [
        Color(hex: "#FFF9F0"),
        Color(hex: "#FFF6E9"),
        Color(hex: "#FFF3E2")
    ]

    var body: some View {
        ZStack {
            // Background with animated gradients
            ZStack {
                // Primary gradient background
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "#FF9800"), Color(hex: "#FFA726")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 200)
                .offset(y: -UIScreen.main.bounds.height * 0.25)
                
                // Animated decorative elements
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 200, height: 200)
                        .offset(x: -100, y: -150)
                        .scaleEffect(animatingBackground ? 1.1 : 1.0)
                    
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 150, height: 150)
                        .offset(x: 150, y: -180)
                        .scaleEffect(animatingBackground ? 0.9 : 1.0)
                    
                    Circle()
                        .fill(Color.white.opacity(0.05))
                        .frame(width: 300, height: 300)
                        .offset(x: 70, y: -100)
                        .scaleEffect(animatingBackground ? 1.05 : 0.95)
                }
                .animation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animatingBackground)
                
                Color(hex: "#FFFAF5")
                    .offset(y: 100)
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Improved header with blending effect
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 120)
                    
                    VStack(spacing: 8) {
                        Text("Post a Ride")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                        
                        Text("Share your journey, connect with travelers")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.white.opacity(0.9))
                            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                    }
                    .padding(.top, 45)
                    .padding(.bottom, 20)
                }
                
                // Loading Indicator
                if isLoading {
                    Spacer()
                    VStack(spacing: 25) {
                        LoadingAnimationView()
                            .frame(width: 220, height: 220)
                        
                        Text("Loading your details...")
                            .font(.headline)
                            .foregroundColor(AppColors.contentText)
                    }
                    Spacer()
                } else {
                    // Main Content with redesigned cards
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 22) {
                            // Trip Details Card
                            VStack(alignment: .leading, spacing: 18) {
                                HStack {
                                    IconWithGlow(iconName: "map.fill")
                                    
                                    Text("Trip Details")
                                        .modifier(PostRideSectionTitleModifier())
                                }
                                
                                // Enhanced route visualization
                                HStack(spacing: 15) {
                                    VStack(spacing: 10) {
                                        Circle()
                                            .fill(Color.green)
                                            .frame(width: 14, height: 14)
                                        
                                        ForEach(0..<3) { _ in
                                            Circle()
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(width: 4, height: 4)
                                        }
                                        
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 2, height: 30)
                                        
                                        ForEach(0..<3) { _ in
                                            Circle()
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(width: 4, height: 4)
                                        }
                                        
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 14, height: 14)
                                    }
                                    
                                    VStack(spacing: 40) {
                                        CustomTextField(icon: "location.fill", placeholder: "Starting point", text: $origin)
                                        CustomTextField(icon: "mappin.and.ellipse", placeholder: "Destination", text: $destination)
                                    }
                                }
                                
                                // Date picker button with animation
                                Button(action: { showDatePicker.toggle() }) {
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundColor(AppColors.buttonBackground)
                                            .frame(width: 22)
                                        
                                        Text(dateFormatter(date))
                                            .foregroundColor(AppColors.contentText)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(AppColors.contentText.opacity(0.5))
                                            .font(.system(size: 14))
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 18)
                                            .fill(Color.white)
                                            .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18)
                                            .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                                    )
                                }
                                .padding(.vertical, 5)
                                
                                // Price and seats with improved styling
                                HStack(spacing: 15) {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Price per Seat")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(AppColors.contentText.opacity(0.7))
                                        
                                        CustomNumberField(
                                            icon: "dollarsign.circle.fill",
                                            placeholder: "0.00",
                                            prefix: "$",
                                            text: $price,
                                            keyboardType: .decimalPad
                                        )
                                    }
                                    .frame(maxWidth: .infinity)
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Available Seats")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(AppColors.contentText.opacity(0.7))
                                        
                                        CustomNumberField(
                                            icon: "person.2.fill",
                                            placeholder: "0",
                                            text: $seatsAvailable,
                                            keyboardType: .numberPad
                                        )
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .padding()
                            .modifier(PostRideCardModifier(color: cardColors[0]))
                            .offset(y: showingCards ? 0 : 300)
                            .opacity(showingCards ? 1 : 0)
                            .animation(Animation.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0).delay(0.1), value: showingCards)
                            
                            // Vehicle Details Card
                            VStack(alignment: .leading, spacing: 18) {
                                HStack {
                                    IconWithGlow(iconName: "car.fill")
                                    
                                    Text("Vehicle Information")
                                        .modifier(PostRideSectionTitleModifier())
                                }
                                
                                // Vehicle details with enhanced styling
                                VStack(spacing: 15) {
                                    CustomTextField(icon: "car.circle.fill", placeholder: "Vehicle Model", text: $vehicleModel)
                                    
                                    CustomTextField(icon: "rectangle.fill.on.rectangle.fill", placeholder: "License Plate", text: $vehiclePlate)
                                    
                                    // Vehicle type selector (visual only)
                                    HStack(spacing: 15) {
                                        ForEach(["car.fill", "suv.side.fill", "car.side.fill"], id: \.self) { icon in
                                            VStack {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .fill(Color.white)
                                                        .frame(height: 70)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 16)
                                                                .stroke(AppColors.buttonBackground.opacity(0.3), lineWidth: 1)
                                                        )
                                                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                                    
                                                    Image(systemName: icon)
                                                        .font(.system(size: 30))
                                                        .foregroundColor(AppColors.contentText.opacity(0.8))
                                                }
                                                
                                                Text(vehicleTypeName(icon))
                                                    .font(.caption)
                                                    .foregroundColor(AppColors.contentText)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                            .modifier(PostRideCardModifier(color: cardColors[1]))
                            .offset(y: showingCards ? 0 : 300)
                            .opacity(showingCards ? 1 : 0)
                            .animation(Animation.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0).delay(0.2), value: showingCards)
                            
                            // Driver Details Card
                            VStack(alignment: .leading, spacing: 18) {
                                HStack {
                                    IconWithGlow(iconName: "person.fill.badge.plus")
                                    
                                    Text("Driver Verification")
                                        .modifier(PostRideSectionTitleModifier())
                                }
                                
                                // Driver details with enhanced styling
                                VStack(spacing: 18) {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Driver's License")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(AppColors.contentText.opacity(0.7))
                                        
                                        CustomTextField(icon: "doc.text.fill", placeholder: "License Number", text: $driverLicense)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Contact Number")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(AppColors.contentText.opacity(0.7))
                                        
                                        CustomTextField(icon: "phone.fill", placeholder: "Your Phone Number", text: $contactNumber)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Additional Notes")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(AppColors.contentText.opacity(0.7))
                                        
                                        ZStack(alignment: .topLeading) {
                                            if additionalNotes.isEmpty {
                                                Text("Anything passengers should know?")
                                                    .foregroundColor(AppColors.contentText.opacity(0.4))
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 12)
                                            }
                                            
                                            TextEditor(text: $additionalNotes)
                                                .foregroundColor(AppColors.contentText)
                                                .frame(height: 120)
                                                .padding(5)
                                                .background(Color.clear)
                                        }
                                        .background(
                                            RoundedRectangle(cornerRadius: 18)
                                                .fill(Color.white)
                                                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 18)
                                                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                                        )
                                    }
                                }
                            }
                            .padding()
                            .modifier(PostRideCardModifier(color: cardColors[2]))
                            .offset(y: showingCards ? 0 : 300)
                            .opacity(showingCards ? 1 : 0)
                            .animation(Animation.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0).delay(0.3), value: showingCards)
                            
                            // Post Ride Button with improved animation
                            Button(action: postRide) {
                                HStack {
                                    Image(systemName: "paperplane.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                        .rotationEffect(.degrees(animateButton ? 0 : -45))
                                    
                                    Text("Post Your Ride")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                }
                                .padding(.vertical, 5)
                                .scaleEffect(animateButton ? 1.05 : 1)
                                .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateButton)
                            }
                            .modifier(PostRideButtonModifier())
                            .padding(.vertical, 15)
                            .opacity(showingCards ? 1 : 0)
                            .animation(Animation.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0).delay(0.4), value: showingCards)
                            
                            // Error message with enhanced styling
                            if let errorMessage = errorMessage {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.red)
                                    
                                    Text(errorMessage)
                                        .font(.footnote)
                                        .foregroundColor(.red)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.red.opacity(0.1))
                                )
                                .padding(.horizontal)
                                .padding(.bottom)
                            }
                            
                            Spacer(minLength: 60)
                        }
                        .padding(.top, 20)
                    }
                }
            }
            
            // Navigation to HomeView
            NavigationLink(
                destination: HomeView(),
                isActive: $navigateToHome,
                label: { EmptyView() }
            )
        }
        .navigationBarHidden(true)
        .onAppear {
            fetchUserData()
            animatingBackground = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    showingCards = true
                    animateButton = true
                }
            }
        }
        .alert(isPresented: $showSuccessDialog) {
            Alert(
                title: Text("Ride Posted Successfully!"),
                message: Text("Your ride has been posted and is now visible to potential passengers."),
                dismissButton: .default(Text("Continue"), action: {
                    navigateToHome = true
                })
            )
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerView(date: $date, isPresented: $showDatePicker)
                .presentationDetents([.height(450)])
        }
    }
    
    private func dateFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    private func vehicleTypeName(_ icon: String) -> String {
        switch icon {
        case "car.fill":
            return "Sedan"
        case "suv.side.fill":
            return "SUV"
        case "car.side.fill":
            return "Hatchback"
        default:
            return "Other"
        }
    }

    private func fetchUserData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "User not logged in."
            isLoading = false
            return
        }

        FirestoreService.shared.fetchUser(userId: userId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.vehicleModel = user.vehicleModel ?? ""
                    self.vehiclePlate = user.vehiclePlate ?? ""
                    self.driverLicense = user.driverLicense ?? ""
                    self.contactNumber = user.contactNumber
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                isLoading = false
            }
        }
    }
    
    private func postRide() {
        guard let userID = Auth.auth().currentUser?.uid,
              !origin.isEmpty, !destination.isEmpty, !price.isEmpty, !seatsAvailable.isEmpty, !vehicleModel.isEmpty, !vehiclePlate.isEmpty, !driverLicense.isEmpty, !contactNumber.isEmpty else {
            errorMessage = "Please fill in all required fields."
            return
        }
        
        let firestoreTimestamp = Timestamp(date: date)

        let newRideData: [String: Any] = [
                "id": UUID().uuidString,
                "origin": origin,
                "destination": destination,
                "date": firestoreTimestamp,
                "price": Double(price) ?? 0.0,
                "seatsAvailable": Int(seatsAvailable) ?? 0,
                "driverID": userID,
                "vehicleModel": vehicleModel,
                "vehiclePlate": vehiclePlate,
                "driverLicense": driverLicense,
                "contactNumber": contactNumber,
                "additionalNotes": additionalNotes
            ]
            
            FirestoreService.shared.addRide(rideData: newRideData) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        showSuccessDialog = true
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            }
    }
}

// Enhanced Date Picker View
struct DatePickerView: View {
    @Binding var date: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Select Departure Date")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.contentText)
                
                Spacer()
                
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(AppColors.contentText.opacity(0.6))
                }
            }
            .padding()
            
            // Calendar style picker
            DatePicker("", selection: $date, displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
                .padding(.horizontal)
                .tint(AppColors.buttonBackground)
            
            // Confirm button
            Button(action: { isPresented = false }) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Confirm Date")
                        .fontWeight(.semibold)
                }
            }
            .modifier(PostRideButtonModifier())
            .padding(.bottom, 30)
        }
        .background(Color(hex: "#FFFAF5"))
    }
}

// Enhanced loading animation
struct LoadingAnimationView: View {
    @State private var rotationAngle: Double = 0
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Background layers
            Circle()
                .fill(AppColors.buttonBackground.opacity(0.1))
                .frame(width: 140, height: 140)
            
            Circle()
                .fill(AppColors.buttonBackground.opacity(0.05))
                .frame(width: 180, height: 180)
            
            // Rotating dot pattern
            ForEach(0..<8) { i in
                Circle()
                    .fill(AppColors.buttonBackground.opacity(0.8))
                    .frame(width: 12, height: 12)
                    .offset(y: -60)
                    .rotationEffect(.degrees(Double(i) * 45 + rotationAngle))
                    .opacity(isAnimating ? 1 : 0.3)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever()
                            .delay(Double(i) * 0.1),
                        value: isAnimating
                    )
            }
            
            // Car icon
            Image(systemName: "car.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 65, height: 65)
                .foregroundColor(AppColors.buttonBackground)
                .shadow(color: AppColors.buttonBackground.opacity(0.3), radius: 10, x: 0, y: 5)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isAnimating)
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 3).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
            
            isAnimating = true
        }
    }
}

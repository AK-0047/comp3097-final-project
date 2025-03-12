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

// Custom modifiers for PostRideView
struct PostRideCardModifier: ViewModifier {
    var color: Color = .white
    var shadowColor: Color = Color.black.opacity(0.1)
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(color)
                    .shadow(color: shadowColor, radius: 10, x: 0, y: 5)
            )
            .padding(.horizontal)
            .padding(.bottom, 15)
    }
}

struct PostRideInputModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
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
                        LinearGradient(
                            gradient: Gradient(colors: [AppColors.buttonBackground, Color(hex: "#FF7800")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    } else {
                        Color.white
                    }
                }
            )
            .clipShape(Capsule())
            .shadow(color: isMain ? AppColors.buttonBackground.opacity(0.4) : Color.gray.opacity(0.2),
                    radius: isMain ? 8 : 5,
                    x: 0,
                    y: isMain ? 4 : 2)
            .overlay(
                Capsule()
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
            .padding(.bottom, 10)
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
    
    // Form validation
    @State private var isValid = false
    
    // Colors for cards
    let cardColors = [
        Color(hex: "#FFF6E9"),
        Color(hex: "#FFF0E2"),
        Color(hex: "#FFECD9")
    ]

    var body: some View {
        ZStack {
            // Background pattern
            VStack(spacing: 0) {
                Color(hex: "#FF9500")
                    .frame(height: 160)
                Color(hex: "#FFFAF0")
            }
            .edgesIgnoringSafeArea(.all)
            
            // Background decorative elements
            VStack {
                HStack {
                    ForEach(0..<3) { i in
                        Circle()
                            .fill(Color.white.opacity(0.15))
                            .frame(width: 30 + CGFloat(i * 20), height: 30 + CGFloat(i * 20))
                            .offset(x: -10 + CGFloat(i * 15), y: 20 + CGFloat(i * 10))
                    }
                    Spacer()
                }
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                ZStack(alignment: .bottom) {
                    Color.clear
                        .frame(height: 100)
                    
                    VStack {
                    VStack(spacing: 5) {
                        Text("Post a Ride")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Share your journey with others")
                            .font(.subheadline)
                            .foregroundColor(Color.white.opacity(0.8))
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 15)
                }
                }
                
                // Loading Indicator
                if isLoading {
                    Spacer()
                    VStack(spacing: 20) {
                        LottieAnimationView(animationName: "loading_car")
                            .frame(width: 200, height: 200)
                        
                        Text("Loading your details...")
                            .font(.headline)
                            .foregroundColor(AppColors.contentText)
                    }
                    Spacer()
                } else {
                    // Main Content
                    ScrollView {
                        VStack(spacing: 20) {
                            // Trip Details Card
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Image(systemName: "map.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(AppColors.buttonBackground)
                                        .padding(12)
                                        .background(
                                            Circle()
                                                .fill(AppColors.buttonBackground.opacity(0.15))
                                        )
                                    
                                    Text("Trip Details")
                                        .modifier(PostRideSectionTitleModifier())
                                }
                                
                                // Route visualization
                                HStack(spacing: 15) {
                                    VStack(spacing: 8) {
                                        Circle()
                                            .fill(Color.green)
                                            .frame(width: 12, height: 12)
                                        
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 2, height: 40)
                                        
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 12, height: 12)
                                    }
                                    
                                    VStack(spacing: 35) {
                                        CustomTextField(icon: "location.fill", placeholder: "Enter origin", text: $origin)
                                        CustomTextField(icon: "mappin.and.ellipse", placeholder: "Enter destination", text: $destination)
                                    }
                                }
                                
                                // Date picker button with animation
                                Button(action: { showDatePicker.toggle() }) {
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundColor(AppColors.contentText)
                                            .padding(.trailing, 5)
                                        
                                        Text(dateFormatter(date))
                                            .foregroundColor(AppColors.contentText)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(AppColors.contentText.opacity(0.5))
                                            .font(.system(size: 14))
                                    }
                                    .modifier(PostRideInputModifier())
                                }
                                .padding(.vertical, 5)
                                
                                // Price and seats in a single row
                                HStack(spacing: 15) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Price")
                                            .font(.subheadline)
                                            .foregroundColor(AppColors.contentText.opacity(0.7))
                                        
                                        HStack {
                                            Text("$")
                                                .foregroundColor(AppColors.contentText)
                                            
                                            TextField("0.00", text: $price)
                                                .keyboardType(.decimalPad)
                                                .foregroundColor(AppColors.contentText)
                                        }
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white)
                                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                                        )
                                    }
                                    .frame(maxWidth: .infinity)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Available Seats")
                                            .font(.subheadline)
                                            .foregroundColor(AppColors.contentText.opacity(0.7))
                                        
                                        HStack {
                                            Image(systemName: "person.2.fill")
                                                .foregroundColor(AppColors.contentText)
                                                .font(.system(size: 14))
                                            
                                            TextField("0", text: $seatsAvailable)
                                                .keyboardType(.numberPad)
                                                .foregroundColor(AppColors.contentText)
                                        }
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white)
                                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
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
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Image(systemName: "car.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(AppColors.buttonBackground)
                                        .padding(12)
                                        .background(
                                            Circle()
                                                .fill(AppColors.buttonBackground.opacity(0.15))
                                        )
                                    
                                    Text("Vehicle Information")
                                        .modifier(PostRideSectionTitleModifier())
                                }
                                
                                // Vehicle details with icons
                                VStack(spacing: 15) {
                                    HStack(spacing: 15) {
                                        Image(systemName: "car.circle")
                                            .font(.system(size: 24))
                                            .foregroundColor(AppColors.contentText.opacity(0.6))
                                            .frame(width: 40)
                                        
                                        TextField("Vehicle Model", text: $vehicleModel)
                                            .foregroundColor(AppColors.contentText)
                                            .padding()
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.white)
                                                    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                                            )
                                    }
                                    
                                    HStack(spacing: 15) {
                                        Image(systemName: "number.square")
                                            .font(.system(size: 24))
                                            .foregroundColor(AppColors.contentText.opacity(0.6))
                                            .frame(width: 40)
                                        
                                        TextField("License Plate", text: $vehiclePlate)
                                            .foregroundColor(AppColors.contentText)
                                            .padding()
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.white)
                                                    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                                            )
                                    }
                                }
                            }
                            .padding()
                            .modifier(PostRideCardModifier(color: cardColors[1]))
                            .offset(y: showingCards ? 0 : 300)
                            .opacity(showingCards ? 1 : 0)
                            .animation(Animation.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0).delay(0.2), value: showingCards)
                            
                            // Driver Details Card
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Image(systemName: "person.fill.badge.plus")
                                        .font(.system(size: 20))
                                        .foregroundColor(AppColors.buttonBackground)
                                        .padding(12)
                                        .background(
                                            Circle()
                                                .fill(AppColors.buttonBackground.opacity(0.15))
                                        )
                                    
                                    Text("Driver Verification")
                                        .modifier(PostRideSectionTitleModifier())
                                }
                                
                                // Driver details with custom styling
                                VStack(spacing: 15) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Driver's License")
                                            .font(.subheadline)
                                            .foregroundColor(AppColors.contentText.opacity(0.7))
                                        
                                        HStack {
                                            Image(systemName: "doc.text.fill")
                                                .foregroundColor(AppColors.contentText.opacity(0.7))
                                            TextField("", text: $driverLicense)
                                                .foregroundColor(AppColors.contentText)
                                        }
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white)
                                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                                        )
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Contact Number")
                                            .font(.subheadline)
                                            .foregroundColor(AppColors.contentText.opacity(0.7))
                                        
                                        HStack {
                                            Image(systemName: "phone.fill")
                                                .foregroundColor(AppColors.contentText.opacity(0.7))
                                            TextField("", text: $contactNumber)
                                                .keyboardType(.phonePad)
                                                .foregroundColor(AppColors.contentText)
                                        }
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white)
                                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                                        )
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Additional Notes")
                                            .font(.subheadline)
                                            .foregroundColor(AppColors.contentText.opacity(0.7))
                                        
                                        TextEditor(text: $additionalNotes)
                                            .foregroundColor(AppColors.contentText)
                                            .frame(height: 100)
                                            .padding(5)
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.white)
                                                    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                            )
                                    }
                                }
                            }
                            .padding()
                            .modifier(PostRideCardModifier(color: cardColors[2]))
                            .offset(y: showingCards ? 0 : 300)
                            .opacity(showingCards ? 1 : 0)
                            .animation(Animation.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0).delay(0.3), value: showingCards)
                            
                            // Post Ride Button
                            Button(action: postRide) {
                                HStack {
                                    Image(systemName: "paperplane.fill")
                                        .font(.system(size: 16, weight: .semibold))
                                        .rotationEffect(.degrees(animateButton ? 0 : -45))
                                    
                                    Text("Post Your Ride")
                                        .fontWeight(.bold)
                                }
                                .scaleEffect(animateButton ? 1.05 : 1)
                                .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateButton)
                            }
                            .modifier(PostRideButtonModifier())
                            .padding(.vertical, 10)
                            .opacity(showingCards ? 1 : 0)
                            .animation(Animation.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0).delay(0.4), value: showingCards)
                            
                            // Error message
                            if let errorMessage = errorMessage {
                                Text(errorMessage)
                                    .font(.footnote)
                                    .foregroundColor(.red)
                                    .padding(.horizontal)
                                    .padding(.bottom)
                            }
                            
                            Spacer(minLength: 50)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    showingCards = true
                    animateButton = true
                }
            }
        }
        .alert(isPresented: $showSuccessDialog) {
            Alert(
                title: Text("Ride Posted!"),
                message: Text("Your ride has been posted successfully and is now visible to potential passengers."),
                dismissButton: .default(Text("Continue"), action: {
                    navigateToHome = true
                })
            )
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerView(date: $date, isPresented: $showDatePicker)
                .presentationDetents([.height(400)])
        }
    }
    
    private func dateFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
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

// Custom Date Picker View
struct DatePickerView: View {
    @Binding var date: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(AppColors.contentText.opacity(0.6))
                }
                .padding()
            }
            
            Text("Select Departure Date")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppColors.contentText)
            
            // Calendar style picker
            DatePicker("", selection: $date, displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
                .padding(.horizontal)
            
            // Confirm button
            Button(action: { isPresented = false }) {
                Text("Confirm Date")
                    .fontWeight(.semibold)
            }
            .modifier(PostRideButtonModifier())
            .padding(.bottom, 30)
        }
        .background(Color.white)
    }
}

// Note: This is a placeholder for a Lottie animation view. In a real app, you would implement this with Lottie.
struct LottieAnimationView: View {
    var animationName: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(AppColors.buttonBackground.opacity(0.1))
                .frame(width: 120, height: 120)
            
            Image(systemName: "car.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(AppColors.buttonBackground)
        }
    }
}

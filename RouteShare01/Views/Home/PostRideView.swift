import SwiftUI
import FirebaseAuth
import FirebaseFirestore

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
    @State private var activeSection: FormSection = .trip

    // Sections for form organization
    enum FormSection: String, CaseIterable {
        case trip = "Trip Details"
        case vehicle = "Vehicle Details"
        case driver = "Driver Verification"
    }

    var body: some View {
        ZStack {
            // Background
            AppColors.background
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Enhanced header with graphic elements
                PostHeaderView(title: "Post a Ride")
                
                if isLoading {
                    LoadingView()
                } else {
                    // Segmented control for sections
                    SectionSelector(activeSection: $activeSection)
                        .padding(.horizontal)
                        .padding(.top, 5)
                    
                    // Form content
                    ScrollView {
                        VStack(spacing: 20) {
                            // Section content based on active section
                            switch activeSection {
                            case .trip:
                                TripDetailsSection(
                                    origin: $origin,
                                    destination: $destination,
                                    date: $date,
                                    showDatePicker: $showDatePicker,
                                    dateFormatter: dateFormatter,
                                    price: $price,
                                    seatsAvailable: $seatsAvailable
                                )
                            case .vehicle:
                                VehicleDetailsSection(
                                    vehicleModel: $vehicleModel,
                                    vehiclePlate: $vehiclePlate
                                )
                            case .driver:
                                DriverVerificationSection(
                                    driverLicense: $driverLicense,
                                    contactNumber: $contactNumber,
                                    additionalNotes: $additionalNotes
                                )
                            }
                            
                            // Error message
                            if let errorMessage = errorMessage {
                                Text(errorMessage)
                                    .font(.footnote)
                                    .foregroundColor(.red)
                                    .padding(.top, 5)
                                    .padding(.horizontal)
                            }
                            
                            // Post button always visible at bottom regardless of section
                            PostRideButton(action: postRide)
                                .padding(.vertical, 20)
                                .padding(.horizontal)
                        }
                        .padding(.bottom, 30)
                    }
                }
                
                // Navigation to HomeView
                NavigationLink(
                    destination: HomeView(),
                    isActive: $navigateToHome,
                    label: { EmptyView() }
                )
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $showSuccessDialog) {
            Alert(
                title: Text("Success!"),
                message: Text("Your ride has been posted successfully."),
                dismissButton: .default(Text("OK"), action: {
                    navigateToHome = true
                })
            )
        }
        .onAppear {
            fetchUserData()
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(date: $date, showDatePicker: $showDatePicker)
        }
    }
    
    private func dateFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d, yyyy"
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

// MARK: - Components

struct PostHeaderView: View {
    var title: String
    
    var body: some View {
        ZStack(alignment: .top) {
            // Header background
            AppColors.buttonBackground
                .frame(height: 180)
                .clipShape(
                    RoundedShape()
                )
                .edgesIgnoringSafeArea(.top)
            
            VStack(spacing: 12) {
                // Car icons in a row for visual interest
                HStack(spacing: 20) {
                    ForEach(0..<3) { i in
                        Image(systemName: "car.fill")
                            .foregroundColor(AppColors.buttonText.opacity(0.7))
                            .offset(y: CGFloat(5 - i * 5))
                    }
                }
                .padding(.top, 35)
                
                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppColors.buttonText)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                    .padding(.bottom, 10)
            }
        }
        .frame(height: 120)
    }
}


struct SectionSelector: View {
    @Binding var activeSection: PostRideView.FormSection
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(PostRideView.FormSection.allCases, id: \.self) { section in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        activeSection = section
                    }
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: iconForSection(section))
                            .font(.system(size: 16, weight: .medium))
                        
                        Text(section.rawValue)
                            .font(.caption)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(activeSection == section ? AppColors.buttonBackground : AppColors.contentText.opacity(0.6))
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(activeSection == section ? AppColors.buttonBackground.opacity(0.15) : Color.clear)
                    )
                }
            }
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.buttonText)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
    
    private func iconForSection(_ section: PostRideView.FormSection) -> String {
        switch section {
        case .trip: return "mappin.and.ellipse"
        case .vehicle: return "car.fill"
        case .driver: return "person.crop.circle.badge.checkmark"
        }
    }
}

struct TripDetailsSection: View {
    @Binding var origin: String
    @Binding var destination: String
    @Binding var date: Date
    @Binding var showDatePicker: Bool
    var dateFormatter: (Date) -> String
    @Binding var price: String
    @Binding var seatsAvailable: String
    
    var body: some View {
        VStack(spacing: 16) {
            // Origin-destination with connecting line
            VStack(spacing: 0) {
                // Origin field
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(AppColors.buttonBackground)
                            .frame(width: 12, height: 12)
                    }
                    
                    Text("FROM")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.contentText.opacity(0.7))
                        .frame(width: 50, alignment: .leading)
                    
                    EnhancedTextField(placeholder: "Your starting point", text: $origin)
                }
                .padding(.vertical, 14)
                .padding(.horizontal)
                .background(AppColors.buttonText)
                .cornerRadius(12)
                
                // Connecting line
                HStack {
                    Rectangle()
                        .fill(AppColors.contentText.opacity(0.2))
                        .frame(width: 2, height: 20)
                        .padding(.leading, 17)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                // Destination field
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(AppColors.buttonBackground)
                            .frame(width: 12, height: 12)
                    }
                    
                    Text("TO")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.contentText.opacity(0.7))
                        .frame(width: 50, alignment: .leading)
                    
                    EnhancedTextField(placeholder: "Your destination", text: $destination)
                }
                .padding(.vertical, 14)
                .padding(.horizontal)
                .background(AppColors.buttonText)
                .cornerRadius(12)
            }
            .padding(.horizontal)
            
            // Date selector
            Button(action: { showDatePicker.toggle() }) {
                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 18))
                        .foregroundColor(AppColors.buttonBackground)
                        .frame(width: 24, height: 24)
                    
                    Text(dateFormatter(date))
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.contentText)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.contentText.opacity(0.4))
                }
                .padding()
                .background(AppColors.buttonText)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                .padding(.horizontal)
            }
            
            // Price and seats
            HStack(spacing: 15) {
                // Price field
                VStack(alignment: .leading, spacing: 6) {
                    Text("PRICE")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.contentText.opacity(0.7))
                    
                    HStack {
                        Text("$")
                            .font(.headline)
                            .foregroundColor(AppColors.buttonBackground)
                        
                        TextField("0.00", text: $price)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 18))
                            .foregroundColor(AppColors.contentText)
                    }
                    .padding()
                    .background(AppColors.buttonText)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                }
                .frame(maxWidth: .infinity)
                
                // Seats field
                VStack(alignment: .leading, spacing: 6) {
                    Text("SEATS")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.contentText.opacity(0.7))
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .font(.headline)
                            .foregroundColor(AppColors.buttonBackground)
                        
                        TextField("0", text: $seatsAvailable)
                            .keyboardType(.numberPad)
                            .font(.system(size: 18))
                            .foregroundColor(AppColors.contentText)
                    }
                    .padding()
                    .background(AppColors.buttonText)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
        }
        .padding(.top, 10)
    }
}

struct VehicleDetailsSection: View {
    @Binding var vehicleModel: String
    @Binding var vehiclePlate: String
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                VehicleHeader()
                
                // Vehicle model
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(AppColors.buttonBackground.opacity(0.2))
                            .frame(width: 36, height: 36)
                        
                        Image(systemName: "car.fill")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.buttonBackground)
                    }
                    
                    EnhancedTextField(placeholder: "Vehicle Make & Model", text: $vehicleModel)
                }
                .padding()
                .background(AppColors.buttonText)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                
                // License plate
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(AppColors.buttonBackground.opacity(0.2))
                            .frame(width: 36, height: 36)
                        
                        Image(systemName: "rectangle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.buttonBackground)
                    }
                    
                    EnhancedTextField(placeholder: "License Plate Number", text: $vehiclePlate)
                }
                .padding()
                .background(AppColors.buttonText)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            }
            .padding(.horizontal)
        }
        .padding(.top, 20)
    }
}

struct VehicleHeader: View {
    var body: some View {
        HStack(spacing: 15) {
            // Car icon in circle
            ZStack {
                Circle()
                    .fill(AppColors.buttonBackground.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "car.fill")
                    .font(.system(size: 25))
                    .foregroundColor(AppColors.buttonBackground)
            }
            
            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text("Your Vehicle")
                    .font(.headline)
                    .foregroundColor(AppColors.contentText)
                
                Text("This information helps riders identify your car")
                    .font(.caption)
                    .foregroundColor(AppColors.contentText.opacity(0.7))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.buttonBackground.opacity(0.1))
        .cornerRadius(12)
    }
}

struct DriverVerificationSection: View {
    @Binding var driverLicense: String
    @Binding var contactNumber: String
    @Binding var additionalNotes: String
    
    var body: some View {
        VStack(spacing: 20) {
            VerificationHeader()
                .padding(.horizontal)
            
            // Driver's license
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(AppColors.buttonBackground.opacity(0.2))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: "person.text.rectangle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.buttonBackground)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Driver's License")
                        .font(.caption)
                        .foregroundColor(AppColors.contentText.opacity(0.7))
                    
                    TextField("Enter your license number", text: $driverLicense)
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.contentText)
                }
            }
            .padding()
            .background(AppColors.buttonText)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            .padding(.horizontal)
            
            // Contact number
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(AppColors.buttonBackground.opacity(0.2))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: "phone.fill")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.buttonBackground)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Contact Number")
                        .font(.caption)
                        .foregroundColor(AppColors.contentText.opacity(0.7))
                    
                    TextField("Enter your phone number", text: $contactNumber)
                        .keyboardType(.phonePad)
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.contentText)
                }
            }
            .padding()
            .background(AppColors.buttonText)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            .padding(.horizontal)
            
            // Additional notes
            VStack(alignment: .leading, spacing: 8) {
                Text("ADDITIONAL NOTES")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.contentText.opacity(0.7))
                
                TextEditor(text: $additionalNotes)
                    .frame(minHeight: 100)
                    .foregroundColor(AppColors.contentText)
                    .padding(8)
                    .background(AppColors.buttonText)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.contentText.opacity(0.2), lineWidth: 1)
                    )
            }
            .padding(.horizontal)
        }
        .padding(.top, 20)
    }
}

struct VerificationHeader: View {
    var body: some View {
        HStack(spacing: 15) {
            // Icon
            ZStack {
                Circle()
                    .fill(AppColors.buttonBackground.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "shield.checkmark.fill")
                    .font(.system(size: 25))
                    .foregroundColor(AppColors.buttonBackground)
            }
            
            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text("Driver Verification")
                    .font(.headline)
                    .foregroundColor(AppColors.contentText)
                
                Text("This information ensures the safety of all users")
                    .font(.caption)
                    .foregroundColor(AppColors.contentText.opacity(0.7))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.buttonBackground.opacity(0.1))
        .cornerRadius(12)
    }
}

struct EnhancedTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .font(.system(size: 16))
            .foregroundColor(AppColors.contentText)
    }
}

struct PostRideButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 18))
                
                Text("POST YOUR RIDE")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 16))
            }
            .foregroundColor(AppColors.buttonText)
            .padding()
            .background(AppColors.buttonBackground)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

struct DatePickerSheet: View {
    @Binding var date: Date
    @Binding var showDatePicker: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Select Trip Date")
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
            
            // Date picker
            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
                .padding()
                .background(AppColors.background)
            
            // Confirmation button
            Button(action: { showDatePicker = false }) {
                Text("Confirm Date")
                    .font(.headline)
                    .foregroundColor(AppColors.buttonText)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColors.buttonBackground)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .padding(.bottom, 24)
            }
            .background(AppColors.background)
        }
        .background(AppColors.background)
        .cornerRadius(20)
    }
}

// MARK: - Custom Shapes

struct RoundedShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        // Start from top-left
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height * 0.8))
        
        // Bottom curve
        path.addCurve(
            to: CGPoint(x: 0, y: height * 0.8),
            control1: CGPoint(x: width * 0.75, y: height + 20),
            control2: CGPoint(x: width * 0.25, y: height * 0.6)
        )
        
        path.closeSubpath()
        return path
    }
}

// MARK: - Preview
struct PostRideView_Previews: PreviewProvider {
    static var previews: some View {
        PostRideView()
    }
}

import SwiftUI
import FirebaseAuth

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

    var body: some View {
        VStack(spacing: 0) {
            // **Fixed Header**
            VStack {
                HStack(spacing: 8) {
                    Image(systemName: "car.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(AppColors.buttonBackground)
                    
                    Text("Post a Ride")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.contentText)
                }
                .padding(.top, 20)
                .padding(.bottom, 10)
            }
            .frame(maxWidth: .infinity)
            .background(AppColors.background)
            .zIndex(1)
            
            // **Loading Indicator**
            if isLoading {
                ProgressView("Loading user info...")
                    .padding(.top, 20)
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        // **Trip Details**
                        SectionTitle(title: "Trip Details")
                        CustomTextField(icon: "location.fill", placeholder: "Enter origin", text: $origin)
                        CustomTextField(icon: "mappin.and.ellipse", placeholder: "Enter destination", text: $destination)
                        
                        // **Date Picker Button**
                        Button(action: { showDatePicker.toggle() }) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(AppColors.contentText)
                                Text(dateFormatter(date))
                                    .foregroundColor(AppColors.contentText)
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: 0.9 * UIScreen.main.bounds.width)
                            .background(AppColors.background)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.contentText, lineWidth: 1))
                        }
                        
                        CustomTextField(icon: "dollarsign.circle.fill", placeholder: "Enter Price", text: $price)
                            .keyboardType(.decimalPad)
                        CustomTextField(icon: "person.2.fill", placeholder: "Available Seats", text: $seatsAvailable)
                            .keyboardType(.numberPad)

                        // **Vehicle Details**
                        SectionTitle(title: "Vehicle Details")
                        CustomTextField(icon: "car.fill", placeholder: "Vehicle Model", text: $vehicleModel)
                        CustomTextField(icon: "number.circle.fill", placeholder: "License Plate Number", text: $vehiclePlate)

                        // **Driver Verification**
                        SectionTitle(title: "Driver Verification")
                        CustomTextField(icon: "doc.text.fill", placeholder: "Driver's License Number", text: $driverLicense)
                        CustomTextField(icon: "phone.fill", placeholder: "Contact Number", text: $contactNumber)
                            .keyboardType(.phonePad)
                        
                        CustomTextField(icon: "note.text", placeholder: "Additional Notes", text: $additionalNotes)
                        
                        // **Post Ride Button**
                        Button(action: postRide) {
                            HStack {
                                Image(systemName: "car.fill")
                                Text("Post Ride")
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(AppColors.buttonText)
                            .padding()
                            .frame(maxWidth: 0.9 * UIScreen.main.bounds.width)
                            .background(AppColors.buttonBackground)
                            .cornerRadius(12)
                        }
                        .padding(.top, 20)
                        
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding(.top, 5)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical)
                }
            }
            
            // **Navigation to HomeView**
            NavigationLink(
                destination: HomeView(),
                isActive: $navigateToHome,
                label: { EmptyView() }
            )
        }
        .background(AppColors.background.edgesIgnoringSafeArea(.all))
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
                .frame(maxWidth: 0.9 * UIScreen.main.bounds.width)
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

        let newRideData: [String: Any] = [
                "id": UUID().uuidString,
                "origin": origin,
                "destination": destination,
                "date": date,
                "price": Double(price) ?? 0.0,
                "seatsAvailable": Int(seatsAvailable) ?? 0,
                "driverID": userID,
                "vehicleModel": vehicleModel,
                "vehiclePlate": vehiclePlate,
                "driverLicense": driverLicense,
                "contactNumber": contactNumber,
                "additionalNotes": additionalNotes
            ]
            
            FirestoreService.shared.addRide(ride: newRideData) { result in
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

// **Reusable Section Title**
struct SectionTitle: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(AppColors.contentText)
            .padding(.horizontal, 20)
    }
}

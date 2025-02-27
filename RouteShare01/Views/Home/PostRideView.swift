import SwiftUI

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
    @State private var navigateToHome = false
    
    var body: some View {
        VStack(spacing: 0) {
            // **Fixed Header Without Layering**
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
            .background(AppColors.background)  // Ensures no layering effect
            .zIndex(1)
            
            // **Scrollable Content**
            ScrollView {
                // **Instruction Section**
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(AppColors.buttonBackground)
                        Text("You're posting this trip as a driver.")
                            .font(.headline)
                            .foregroundColor(AppColors.contentText)
                    }
                    Text("Fill in the details below to share your ride with passengers in a secure and reliable manner.")
                        .font(.subheadline)
                        .foregroundColor(AppColors.contentText.opacity(0.7))
                }
                .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Trip Details")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.contentText)
                        .padding(.horizontal, 20)
                    
                    CustomTextField(icon: "location.fill", placeholder: "Enter origin", text: $origin)
                    CustomTextField(icon: "mappin.and.ellipse", placeholder: "Enter destination", text: $destination)
                    
                    // **Date Picker Button (Fix Applied)**
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
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(AppColors.contentText, lineWidth: 1)
                        )
                    }
                    
                    CustomTextField(icon: "dollarsign.circle.fill", placeholder: "Enter Price", text: $price)
                        .keyboardType(.decimalPad)
                    
                    CustomTextField(icon: "person.2.fill", placeholder: "Available Seats", text: $seatsAvailable)
                        .keyboardType(.numberPad)
                    
                    Text("Vehicle Details")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.contentText)
                        .padding(.horizontal, 20)
                    
                    CustomTextField(icon: "car.fill", placeholder: "Vehicle Model", text: $vehicleModel)
                    CustomTextField(icon: "number.circle.fill", placeholder: "License Plate Number", text: $vehiclePlate)
                    
                    Text("Driver Verification")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.contentText)
                        .padding(.horizontal, 20)
                    
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
                }
                .padding(.horizontal, 20)
                .padding(.vertical)
            }
            
            // **Navigation to HomeView after posting**
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
        .sheet(isPresented: $showDatePicker) {
            // **Fixed Date Picker Modal**
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
    
    private func postRide() {
        guard !origin.isEmpty, !destination.isEmpty, !price.isEmpty, !seatsAvailable.isEmpty, !vehicleModel.isEmpty, !vehiclePlate.isEmpty, !driverLicense.isEmpty, !contactNumber.isEmpty else {
            return  // Ensure all fields are filled
        }
        showSuccessDialog = true
    }
}

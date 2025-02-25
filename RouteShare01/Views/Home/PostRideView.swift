import SwiftUI

struct PostRideView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var origin: String = ""
    @State private var destination: String = ""
    @State private var date: Date = Date()
    @State private var price: String = ""
    @State private var seatsAvailable: String = ""
    @State private var showSuccessDialog = false
    @State private var navigateToHome = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Post a Ride")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.contentText)

                // Origin Field
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(AppColors.contentText)
                    TextField("Enter Origin", text: $origin)
                        .foregroundColor(AppColors.contentText)
                }
                .padding()
                .background(AppColors.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppColors.contentText, lineWidth: 1)
                )
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal)

                // Destination Field
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(AppColors.contentText)
                    TextField("Enter Destination", text: $destination)
                        .foregroundColor(AppColors.contentText)
                }
                .padding()
                .background(AppColors.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppColors.contentText, lineWidth: 1)
                )
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal)

                // Date Picker
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(AppColors.contentText)
                    DatePicker("Select Date", selection: $date, displayedComponents: .date)
                        .foregroundColor(AppColors.contentText)
                }
                .padding()
                .background(AppColors.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppColors.contentText, lineWidth: 1)
                )
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal)

                // Price Field
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(AppColors.contentText)
                    TextField("Enter Price", text: $price)
                        .keyboardType(.decimalPad)
                        .foregroundColor(AppColors.contentText)
                }
                .padding()
                .background(AppColors.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppColors.contentText, lineWidth: 1)
                )
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal)

                // Seats Available Field
                HStack {
                    Image(systemName: "person.3.fill")
                        .foregroundColor(AppColors.contentText)
                    TextField("Available Seats", text: $seatsAvailable)
                        .keyboardType(.numberPad)
                        .foregroundColor(AppColors.contentText)
                }
                .padding()
                .background(AppColors.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppColors.contentText, lineWidth: 1)
                )
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal)

                // Post Ride Button
                Button(action: postRide) {
                    HStack {
                        Image(systemName: "car.fill")
                        Text("Post Ride")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(AppColors.buttonText)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(AppColors.buttonBackground)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                Spacer()
                
                // Navigation to HomeView after posting
                NavigationLink(
                    destination: HomeView(),
                    isActive: $navigateToHome,
                    label: { EmptyView() }
                )
            }
            .padding()
            .background(AppColors.background.edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
            .alert(isPresented: $showSuccessDialog) {
                Alert(
                    title: Text("Success!"),
                    message: Text("Your ride has been posted successfully."),
                    dismissButton: .default(Text("OK"), action: {
                        navigateToHome = true  // Redirects to HomeView
                    })
                )
            }
        }
    }

    private func postRide() {
        guard !origin.isEmpty, !destination.isEmpty, !price.isEmpty, !seatsAvailable.isEmpty else {
            return  // Ensure all fields are filled
        }
        showSuccessDialog = true
    }
}

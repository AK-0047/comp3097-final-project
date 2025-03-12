import SwiftUI
import Firebase

struct SignupView: View {
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var contactNumber: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var driverLicense: String = ""
    @State private var vehicleModel: String = ""
    @State private var vehiclePlate: String = ""
    @State private var errorMessage: String?
    @State private var isLoading: Bool = false

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                Spacer()

                VStack(spacing: 8) {
                    Text("Join RouteShare")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(AppColors.contentText.opacity(0.8))

                    Text("Create Your Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.contentText)
                }
                .multilineTextAlignment(.center)

                VStack(spacing: 15) {
                    CustomTextField(icon: "person.fill", placeholder: "Full Name", text: $fullName)
                    CustomTextField(icon: "envelope.fill", placeholder: "Email", text: $email)
                    CustomTextField(icon: "phone.fill", placeholder: "Contact Number", text: $contactNumber)
                        .keyboardType(.phonePad)
                    CustomTextField(icon: "lock.fill", placeholder: "Password", text: $password, isSecure: true)
                    CustomTextField(icon: "lock.fill", placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)
                }
                .padding(.horizontal)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 5)
                }

                // **Sign Up Button**
                Button(action: signUp) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: 30, height: 30)
                    } else {
                        CustomButton(title: "Sign Up", action: signUp)
                    }
                }
                .padding(.horizontal)
                .disabled(isLoading || email.isEmpty || password.isEmpty || fullName.isEmpty || confirmPassword.isEmpty || contactNumber.isEmpty || password != confirmPassword)
                .opacity(isLoading || email.isEmpty || password.isEmpty || fullName.isEmpty || confirmPassword.isEmpty || contactNumber.isEmpty || password != confirmPassword ? 0.6 : 1.0)

                // **Navigation to Login**
                NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                    Text("Already have an account? Login")
                        .foregroundColor(AppColors.contentText.opacity(0.7))
                        .font(.footnote)
                }
                .padding(.top, 8)

                Spacer()
            }
            .padding()
            .background(AppColors.background.edgesIgnoringSafeArea(.all))
        }
        .navigationBarBackButtonHidden(true)
    }

    // **🚀 Handle Sign Up Process**
    private func signUp() {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }

        isLoading = true
        errorMessage = nil

        FirebaseAuthService.shared.signUpUser(
            fullName: fullName,
            email: email,
            password: password,
            contactNumber: contactNumber,
            driverLicense: driverLicense.isEmpty ? nil : driverLicense,
            vehicleModel: vehicleModel.isEmpty ? nil : vehicleModel,
            vehiclePlate: vehiclePlate.isEmpty ? nil : vehiclePlate
        ) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let user):
                    FirestoreService.shared.saveUser(user: user) { firestoreResult in
                        switch firestoreResult {
                        case .success:
                            presentationMode.wrappedValue.dismiss()  // Redirect to login
                        case .failure(let error):
                            errorMessage = error.localizedDescription
                        }
                    }
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

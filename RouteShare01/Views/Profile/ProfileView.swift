import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @State private var isLoggedOut = false
    @State private var showLogoutAlert = false
    @State private var showDeleteAlert = false
    @State private var user: User?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            // Enhanced Header with Gradient Background
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [AppColors.buttonBackground, AppColors.buttonBackground.opacity(0.7)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(edges: .top)
                
                VStack {
                    Text("Profile")
                        .font(.system(size: 22, weight: .bold, design: .rounded)) // Reduced font size further
                        .foregroundColor(.white)
                        .padding(.top, 5) // Reduced padding
                }
            }
            .frame(height: 65)
            .zIndex(1)
            
            ScrollView {
                VStack(spacing: 20) { // CHANGED: Spacing from 25 to 20
                    if isLoading {
                        LoadingView()
                    } else if let user = user {
                        // Enhanced Profile Card with Avatar
                        ProfileCardView(user: user)
                            .offset(y: -5)
                            .padding(.bottom, -20)
                    } else if let errorMessage = errorMessage {
                        ErrorView(message: errorMessage)
                    }
                    
                    // Account Sections with Improved Visual Style
                    SectionContainer {
                        SectionHeader(title: "Account", icon: "person.circle.fill")
                        AccountOptionRow(icon: "pencil.circle.fill", title: "Edit Profile", subtitle: "Update your personal information")
                        AccountOptionRow(icon: "creditcard.fill", title: "Payment Methods", subtitle: "Manage your payment options")
                    }
                    
                    SectionContainer {
                        SectionHeader(title: "Activity", icon: "clock.arrow.circlepath")
                        AccountOptionRow(icon: "car.fill", title: "Ride History", subtitle: "View your past rides and trips")
                    }
                    
                    SectionContainer {
                        SectionHeader(title: "Settings", icon: "gearshape.2.fill")
                        AccountOptionRow(icon: "bell.badge.fill", title: "Notifications", subtitle: "Customize your alerts")
                        AccountOptionRow(icon: "lock.fill", title: "Privacy", subtitle: "Manage your privacy settings")
                        AccountOptionRow(icon: "questionmark.circle.fill", title: "Help & Support", subtitle: "Get assistance when you need it")
                    }
                    
                    // Action Buttons with Improved Styling
                    VStack(spacing: 16) {
                        Button(action: {
                            showLogoutAlert = true
                        }) {
                            HStack {
                                Image(systemName: "power")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Log Out")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(AppColors.buttonText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14) // CHANGED: Padding from 16 to 14
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
                        .alert(isPresented: $showLogoutAlert) {
                            Alert(
                                title: Text("Confirm Logout"),
                                message: Text("Are you sure you want to log out?"),
                                primaryButton: .destructive(Text("Logout")) {
                                    logoutUser()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        
                        Button(action: {
                            showDeleteAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Delete Account")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14) // CHANGED: Padding from 16 to 14
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.red.opacity(0.8), Color.red]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: Color.red.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .alert(isPresented: $showDeleteAlert) {
                            Alert(
                                title: Text("Delete Account?"),
                                message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                                primaryButton: .destructive(Text("Delete")) {
                                    deleteUserAccount()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .padding(.bottom, 16) // ADDED: Extra bottom padding
                }
                .padding(.top, 16) // CHANGED: Top padding from 20 to 16
            }
            .background(
                AppColors.background
                    .edgesIgnoringSafeArea(.all)
            )
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $isLoggedOut) {
            LoginView()
        }
        .onAppear(perform: loadUserData)
    }

    private func loadUserData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "User not logged in"
            isLoading = false
            return
        }
        
        FirestoreService.shared.fetchUser(userId: userId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
                isLoading = false
            }
        }
    }

    private func logoutUser() {
        do {
            try Auth.auth().signOut()
            isLoggedOut = true
        } catch {
            errorMessage = "Failed to log out"
        }
    }

    private func deleteUserAccount() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        FirestoreService.shared.deleteUser(userId: userId) { firestoreResult in
            switch firestoreResult {
            case .success:
                Auth.auth().currentUser?.delete { authError in
                    if let authError = authError {
                        errorMessage = "Error deleting account: \(authError.localizedDescription)"
                    } else {
                        isLoggedOut = true
                    }
                }
            case .failure(let error):
                errorMessage = "Error deleting data: \(error.localizedDescription)"
            }
        }
    }
}

// Enhanced Loading View
struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .padding()
            Text("Loading your profile...")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(AppColors.contentText.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

// Enhanced Error View
struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.orange)
            
            Text("Something went wrong")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(AppColors.contentText)
            
            Text(message)
                .font(.system(size: 16))
                .foregroundColor(AppColors.contentText.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.background)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 20)
    }
}

// Enhanced Profile Card
struct ProfileCardView: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 24) {
            // Avatar with colored border and shadow
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [AppColors.buttonBackground.opacity(0.6), AppColors.buttonBackground]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 130, height: 130)
                    .shadow(color: AppColors.buttonBackground.opacity(0.5), radius: 10, x: 0, y: 5)
                
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110, height: 110)
                    .foregroundColor(.white)
            }
            
            // User Info with better typography
            VStack(spacing: 8) {
                Text(user.fullName)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(AppColors.contentText)
                
                Text(user.email)
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(AppColors.contentText.opacity(0.7))
                
                Divider()
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                
                // Contact info with icons
                VStack(spacing: 12) {
                    ProfileInfoRow(icon: "phone.fill", text: user.contactNumber)
                    
                    if let driverLicense = user.driverLicense, !driverLicense.isEmpty {
                        ProfileInfoRow(icon: "creditcard.fill", text: "License: \(driverLicense)")
                    }
                    
                    if let vehicleModel = user.vehicleModel, !vehicleModel.isEmpty {
                        ProfileInfoRow(icon: "car.fill", text: "\(vehicleModel) (\(user.vehiclePlate ?? "-"))")
                    }
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(AppColors.background)
                .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
        )
        .padding(.horizontal, 20)
    }
}

// Info Row Component
struct ProfileInfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(AppColors.buttonBackground)
                .frame(width: 28, height: 28)
                .background(
                    Circle()
                        .fill(AppColors.buttonBackground.opacity(0.15))
                )
            
            Text(text)
                .font(.system(size: 16, design: .rounded))
                .foregroundColor(AppColors.contentText)
            
            Spacer()
        }
    }
}

// Enhanced Section Container
struct SectionContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 4)
    }
}

// Enhanced Section Header
struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppColors.buttonBackground)
            
            Text(title)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(AppColors.contentText)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 6)
    }
}

// Enhanced Account Option Row
struct AccountOptionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(AppColors.buttonBackground)
                .frame(width: 36, height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColors.buttonBackground.opacity(0.12))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.contentText)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.contentText.opacity(0.6))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.contentText.opacity(0.5))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.background)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

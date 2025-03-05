//import SwiftUI
//
//struct ProfileView: View {
//    @State private var isLoggedOut = false
//    @State private var showLogoutAlert = false
//
//    var body: some View {
//        VStack(spacing: 0) {
//            // **Fixed Header with Proper Background**
//            ZStack {
//                Color(AppColors.background)
//                    .ignoresSafeArea(edges: .top) // Ensure full-width coverage
//                
//                VStack {
//                    Image(systemName: "person.fill")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 30, height: 30)
//                        .foregroundColor(AppColors.buttonBackground)
//                    
//                    Text("Profile")
//                        .font(.title)
//                        .fontWeight(.bold)
//                        .foregroundColor(AppColors.contentText)
//                }
//                .padding(.top, 40) // Adjusted to align properly with safe area
//            }
//            .frame(height: 100)
//            .zIndex(1)
//            
//            ScrollView {
//                VStack(spacing: 20) {
//                    // **Profile Card**
//                    VStack {
//                        Image(systemName: "person.crop.circle.fill")
//                            .resizable()
//                            .frame(width: 100, height: 100)
//                            .foregroundColor(AppColors.contentText)
//                            .overlay(
//                                Circle()
//                                    .stroke(AppColors.buttonBackground, lineWidth: 2)
//                            )
//                            .padding(.bottom, 8)
//
//                        Text("John Doe")
//                            .font(.title2)
//                            .fontWeight(.bold)
//                            .foregroundColor(AppColors.contentText)
//
//                        Text("johndoe@example.com")
//                            .font(.subheadline)
//                            .foregroundColor(AppColors.contentText.opacity(0.7))
//                    }
//                    .padding()
//                    .background(AppColors.background)
//                    .cornerRadius(15)
//                    .shadow(radius: 3)
//                    .padding(.horizontal, 16) // Keep consistent padding
//                    
//                    // **Account Sections**
//                    VStack(spacing: 12) {
//                        SectionHeader(title: "Account")
//                        AccountOptionRow(icon: "pencil", title: "Edit Profile")
//                        AccountOptionRow(icon: "creditcard.fill", title: "Payment Methods")
//
//                        SectionHeader(title: "Activity")
//                        AccountOptionRow(icon: "clock.fill", title: "Ride History")
//
//                        SectionHeader(title: "Settings")
//                        AccountOptionRow(icon: "gearshape.fill", title: "Settings")
//                    }
//                    .padding(.horizontal, 16) // Keep uniform padding
//                    
//                    // **Logout Button - Now Centered & Larger**
//                    Button(action: {
//                        showLogoutAlert = true
//                    }) {
//                        HStack {
//                            Image(systemName: "power")
//                                .foregroundColor(AppColors.buttonText)
//                            Text("Logout")
//                                .fontWeight(.bold)
//                                .foregroundColor(AppColors.buttonText)
//                        }
//                        .padding()
//                        .frame(width: 200) // Adjusted for better positioning
//                        .background(AppColors.buttonBackground)
//                        .cornerRadius(12)
//                        .shadow(radius: 2)
//                        .padding(.top, 30) // Added spacing to center it more
//                    }
//                    .alert(isPresented: $showLogoutAlert) {
//                        Alert(
//                            title: Text("Confirm Logout"),
//                            message: Text("Are you sure you want to log out?"),
//                            primaryButton: .destructive(Text("Logout")) {
//                                logoutUser()
//                            },
//                            secondaryButton: .cancel()
//                        )
//                    }
//                }
//                .padding(.top, 20)
//            }
//            .background(AppColors.background.edgesIgnoringSafeArea(.all))
//        }
//        .navigationBarHidden(true)
//        .fullScreenCover(isPresented: $isLoggedOut) {
//            LoginView()
//        }
//    }
//
//    private func logoutUser() {
//        isLoggedOut = true
//    }
//}
//
//// **Section Header Component**
//struct SectionHeader: View {
//    let title: String
//
//    var body: some View {
//        HStack {
//            Text(title)
//                .font(.headline)
//                .foregroundColor(AppColors.contentText)
//            Spacer()
//        }
//        .padding(.horizontal, 16)
//        .padding(.top, 5)
//    }
//}
//
//// **Account Option Row Component**
//struct AccountOptionRow: View {
//    let icon: String
//    let title: String
//
//    var body: some View {
//        HStack {
//            Image(systemName: icon)
//                .foregroundColor(AppColors.contentText)
//            Text(title)
//                .fontWeight(.medium)
//                .foregroundColor(AppColors.contentText)
//            Spacer()
//            Image(systemName: "chevron.right")
//                .foregroundColor(AppColors.contentText.opacity(0.7))
//        }
//        .padding()
//        .background(AppColors.background)
//        .cornerRadius(10)
//        .overlay(
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(AppColors.buttonBackground, lineWidth: 1)
//        )
//        .shadow(radius: 2)
//        .padding(.horizontal, 16)
//    }
//}


import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @State private var isLoggedOut = false
    @State private var showLogoutAlert = false
    @State private var user: User?
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 0) {
            // **Fixed Header**
            ZStack {
                Color(AppColors.background)
                    .ignoresSafeArea(edges: .top)

                VStack {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(AppColors.buttonBackground)
                    
                    Text("Profile")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.contentText)
                }
                .padding(.top, 40)
            }
            .frame(height: 100)
            .zIndex(1)
            
            ScrollView {
                VStack(spacing: 20) {
                    if isLoading {
                        ProgressView("Loading...")
                    } else if let user = user {
                        // **Profile Card**
                        VStack {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(AppColors.contentText)
                                .overlay(
                                    Circle()
                                        .stroke(AppColors.buttonBackground, lineWidth: 2)
                                )
                                .padding(.bottom, 8)

                            Text(user.fullName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.contentText)

                            Text(user.email)
                                .font(.subheadline)
                                .foregroundColor(AppColors.contentText.opacity(0.7))
                        }
                        .padding()
                        .background(AppColors.background)
                        .cornerRadius(15)
                        .shadow(radius: 3)
                        .padding(.horizontal, 16)
                    } else if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    // **Account Sections**
                    VStack(spacing: 12) {
                        SectionHeader(title: "Account")
                        AccountOptionRow(icon: "pencil", title: "Edit Profile")
                        AccountOptionRow(icon: "creditcard.fill", title: "Payment Methods")

                        SectionHeader(title: "Activity")
                        AccountOptionRow(icon: "clock.fill", title: "Ride History")

                        SectionHeader(title: "Settings")
                        AccountOptionRow(icon: "gearshape.fill", title: "Settings")
                    }
                    .padding(.horizontal, 16)

                    // **Logout Button**
                    Button(action: {
                        showLogoutAlert = true
                    }) {
                        HStack {
                            Image(systemName: "power")
                                .foregroundColor(AppColors.buttonText)
                            Text("Logout")
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.buttonText)
                        }
                        .padding()
                        .frame(width: 200)
                        .background(AppColors.buttonBackground)
                        .cornerRadius(12)
                        .shadow(radius: 2)
                        .padding(.top, 30)
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
                }
                .padding(.top, 20)
            }
            .background(AppColors.background.edgesIgnoringSafeArea(.all))
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
            switch result {
            case .success(let user):
                self.user = user
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
            isLoading = false
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
}

// **Section Header Component**
struct SectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(AppColors.contentText)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 5)
    }
}

// **Account Option Row Component**
struct AccountOptionRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(AppColors.contentText)
            Text(title)
                .fontWeight(.medium)
                .foregroundColor(AppColors.contentText)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(AppColors.contentText.opacity(0.7))
        }
        .padding()
        .background(AppColors.background)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppColors.buttonBackground, lineWidth: 1)
        )
        .shadow(radius: 2)
        .padding(.horizontal, 16)
    }
}

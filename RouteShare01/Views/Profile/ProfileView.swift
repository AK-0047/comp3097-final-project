import SwiftUI

struct ProfileView: View {
    @State private var isLoggedOut = false

    var body: some View {
        VStack(spacing: 0) {
            // Custom Header
            ZStack {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [AppColors.background.opacity(0.9), AppColors.background]), startPoint: .top, endPoint: .bottom))
                    .frame(height: 120)
                    .edgesIgnoringSafeArea(.top)
                
                HStack(spacing: 8) {
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
            }
            .zIndex(1)

            ScrollView {
                VStack(spacing: 20) {
                    // Profile Card
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

                        Text("John Doe")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.contentText)

                        Text("johndoe@example.com")
                            .font(.subheadline)
                            .foregroundColor(AppColors.contentText.opacity(0.7))
                    }
                    .padding()
                    .background(AppColors.background)
                    .cornerRadius(15)
                    .shadow(radius: 3)
                    .padding(.horizontal)

                    // Account Sections
                    VStack(spacing: 10) {
                        SectionHeader(title: "Account")
                        AccountOptionRow(icon: "pencil", title: "Edit Profile")
                        AccountOptionRow(icon: "creditcard.fill", title: "Payment Methods")

                        SectionHeader(title: "Activity")
                        AccountOptionRow(icon: "clock.fill", title: "Ride History")

                        SectionHeader(title: "Settings")
                        AccountOptionRow(icon: "gearshape.fill", title: "Settings")
                    }

                    // Logout Button
                    Button(action: logoutUser) {
                        HStack {
                            Image(systemName: "power")
                                .foregroundColor(AppColors.buttonText)
                            Text("Logout")
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.buttonText)
                            Spacer()
                        }
                        .padding()
                        .background(AppColors.buttonBackground)
                        .cornerRadius(12)
                        .shadow(radius: 2)
                        .padding(.horizontal)
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
    }

    private func logoutUser() {
        isLoggedOut = true
    }
}

// Section Header Component
struct SectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(AppColors.contentText)
            Spacer()
        }
        .padding(.horizontal)
    }
}

// Account Option Row Component
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
        .padding(.horizontal)
    }
}

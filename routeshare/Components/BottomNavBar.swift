import SwiftUI

struct BottomNavBar: View {
    var body: some View {
        HStack {
            Spacer()
            
            // Home Button
            NavigationLink(destination: HomePageView()) {
                VStack {
                    Image(systemName: "house.fill")
                        .foregroundColor(.blue)
                    Text("Home")
                        .font(.caption)
                }
            }
            
            Spacer()
            
            // Trips Button
            NavigationLink(destination: TripsView()) {
                VStack {
                    Image(systemName: "car.fill")
                        .foregroundColor(.orange)
                    Text("Trips")
                        .font(.caption)
                }
            }
            
            Spacer()
            
            // Account Button
            NavigationLink(destination: AccountView()) {
                VStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.purple)
                    Text("Profile")
                        .font(.caption)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.2))
    }
}

#Preview {
    BottomNavBar()
}

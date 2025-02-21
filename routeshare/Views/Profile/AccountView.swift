//
//  ProfileView.swift
//  routeshare
//
//  Created by Anshul Dharmendra Kamboya on 2025-02-21.
//

import SwiftUI

struct AccountView: View {
    // Sample user details
    let userName = "John Doe"
    let userEmail = "john.doe@example.com"
    let profileImageName = "person.circle.fill" // SF Symbol placeholder
    let tripsCount = 12
    let ridesCount = 8
    let rating = 4.5
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: profileImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .foregroundColor(.blue)
                    .padding(.top, 40)
                
                Text(userName)
                    .font(.title)
                    .fontWeight(.bold)
                Text(userEmail)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 30) {
                    VStack {
                        Text("Trips")
                            .font(.headline)
                        Text("\(tripsCount)")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("Rides")
                            .font(.headline)
                        Text("\(ridesCount)")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("Rating")
                            .font(.headline)
                        Text(String(format: "%.1f", rating))
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Account")
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}

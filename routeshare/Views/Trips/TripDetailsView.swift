//
//  TripDetailsView.swift
//  routeshare
//
//  Created by Anshul Dharmendra Kamboya on 2025-02-21.
//

import SwiftUI

struct TripDetailsView: View {
    let route: String = "Toronto - Oshawa"
    let dateTime: String = "15/12/2024, 8:00 AM"
    let driverInfo: String = "Piyush"
    let price: String = "$33.12"
    let paymentMethod: String = "Online"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Trip Details")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Route: \(route)")
                    Text("Date/Time: \(dateTime)")
                    Text("Driver Info: \(driverInfo)")
                    Text("Price: \(price)")
                    Text("Payment Method: \(paymentMethod)")
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
                
                CustomButton(title: "Book Now", backgroundColor: .green) {
                    // Implement booking logic here
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Trip Details")
        }
    }
}

struct TripDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TripDetailsView()
    }
}

//
//  PostTripView.swift
//  routeshare
//
//  Created by Anshul Dharmendra Kamboya on 2025-02-21.
//

import SwiftUI

struct PostTripView: View {
    @State private var departureCity: String = ""
    @State private var destinationCity: String = ""
    @State private var selectedDate: Date = Date()
    @State private var paymentMethod: String = "Online"
    @State private var availableSeats: Int = 1
    
    let paymentMethods = ["Cash", "Credit Card", "Online", "Any"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Post a Trip")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                CustomTextField(placeholder: "Departure City", text: $departureCity, isSecure: false)
                CustomTextField(placeholder: "Destination City", text: $destinationCity, isSecure: false)
                
                VStack(alignment: .leading) {
                    Text("Departure Date/Time")
                        .font(.headline)
                        .padding(.leading)
                    
                    DatePicker("", selection: $selectedDate)
                        .datePickerStyle(.compact)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                VStack(alignment: .leading) {
                    Text("Payment Method")
                        .font(.headline)
                        .padding(.leading)
                    
                    Picker("Payment Method", selection: $paymentMethod) {
                        ForEach(paymentMethods, id: \.self) { method in
                            Text(method)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                VStack(alignment: .leading) {
                    Text("Available Seats")
                        .font(.headline)
                        .padding(.leading)
                    
                    Stepper("\(availableSeats) Seat(s)", value: $availableSeats, in: 1...4)
                        .padding(.horizontal)
                }
                
                CustomButton(title: "Post Trip", backgroundColor: .blue) {
                    // Implement your post trip logic here
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Post a Trip")
        }
    }
}

struct PostTripView_Previews: PreviewProvider {
    static var previews: some View {
        PostTripView()
    }
}

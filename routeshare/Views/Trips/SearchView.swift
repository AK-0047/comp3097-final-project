//
//  SearchView.swift
//  routeshare
//
//  Created by Anshul Dharmendra Kamboya on 2025-02-21.
//

import SwiftUI

struct SearchView: View {
    @State private var departureCity: String = ""
    @State private var destinationCity: String = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedPaymentMethod: String = "Any"
    @State private var availableSeats: Int = 1

    let paymentMethods = ["Any", "Cash", "Credit Card", "Online Payment"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Find Your Ride")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)

                CustomTextField(placeholder: "Departure City", text: $departureCity, isSecure: false)
                CustomTextField(placeholder: "Destination City", text: $destinationCity, isSecure: false)

                VStack(alignment: .leading) {
                    Text("Select Travel Date")
                        .font(.headline)
                        .padding(.leading)
                    
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                VStack(alignment: .leading) {
                    Text("Preferred Payment Method")
                        .font(.headline)
                        .padding(.leading)

                    Picker("Payment Method", selection: $selectedPaymentMethod) {
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
                    Text("Seats Required")
                        .font(.headline)
                        .padding(.leading)
                    
                    Stepper("\(availableSeats) Seat(s)", value: $availableSeats, in: 1...4)
                        .padding(.horizontal)
                }

                NavigationLink(destination: SearchResultsView()) {
                    CustomButton(title: "Search Rides", backgroundColor: .blue) {
                        // Additional search logic can be added here if needed
                    }
                }

                Spacer()
            }
            .padding()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

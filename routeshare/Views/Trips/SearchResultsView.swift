//
//  SearchResultsView.swift
//  routeshare
//
//  Created by Anshul Dharmendra Kamboya on 2025-02-21.
//

import SwiftUI

struct SearchResultsView: View {
    let results = [
        (route: "Toronto - Oshawa", date: "15/12/2024", driver: "Piyush", price: "$33.12"),
        (route: "Ottawa - Montreal", date: "20/12/2024", driver: "John", price: "$25.00")
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Search Results")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                ScrollView {
                    ForEach(results, id: \.route) { result in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Route: \(result.route)")
                                .font(.headline)
                            Text("Date/Time: \(result.date)")
                                .font(.subheadline)
                            Text("Driver Info: \(result.driver)")
                                .font(.subheadline)
                            Text("Price: \(result.price)")
                                .font(.subheadline)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .onTapGesture {
                            // Optionally, you can add navigation logic here
                        }
                    }
                }
                
                NavigationLink(destination: TripDetailsView()) {
                    CustomButton(title: "View Trip Details", backgroundColor: .blue) {
                        // Additional logic if needed
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Results")
        }
    }
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView()
    }
}

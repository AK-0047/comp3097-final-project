//
//  TripsView.swift
//  routeshare
//
//  Created by Anshul Dharmendra Kamboya on 2025-02-21.
//

import SwiftUI

enum TripCategory: String, CaseIterable, Identifiable {
    case upcoming = "Upcoming"
    case requested = "Requested"
    case completed = "Completed"
    
    var id: String { self.rawValue }
}

struct TripsView: View {
    @State private var selectedCategory: TripCategory = .upcoming

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Trip Category", selection: $selectedCategory) {
                    ForEach(TripCategory.allCases) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                Group {
                    switch selectedCategory {
                    case .upcoming:
                        UpcomingTripsView()
                    case .requested:
                        RequestedTripsView()
                    case .completed:
                        CompletedTripsView()
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("Trips")
        }
    }
}

struct UpcomingTripsView: View {
    let upcomingTrips = [
        ("Toronto - Oshawa", "15/12/2024", "Piyush", "$33.12"),
        ("Ottawa - Kingston", "20/12/2024", "Alice", "$45.00")
    ]
    
    var body: some View {
        List(upcomingTrips, id: \.0) { trip in
            VStack(alignment: .leading, spacing: 5) {
                Text("Route: \(trip.0)")
                    .font(.headline)
                Text("Date: \(trip.1)")
                    .font(.subheadline)
                Text("Driver: \(trip.2)")
                    .font(.subheadline)
                Text("Price: \(trip.3)")
                    .font(.subheadline)
            }
            .padding(.vertical, 5)
        }
        .listStyle(PlainListStyle())
    }
}

struct RequestedTripsView: View {
    let requestedTrips = [
        ("Mississauga - Brampton", "10/12/2024", "Pending", "$25.00")
    ]
    
    var body: some View {
        List(requestedTrips, id: \.0) { trip in
            VStack(alignment: .leading, spacing: 5) {
                Text("Route: \(trip.0)")
                    .font(.headline)
                Text("Date: \(trip.1)")
                    .font(.subheadline)
                Text("Status: \(trip.2)")
                    .font(.subheadline)
                Text("Price: \(trip.3)")
                    .font(.subheadline)
            }
            .padding(.vertical, 5)
        }
        .listStyle(PlainListStyle())
    }
}

struct CompletedTripsView: View {
    let completedTrips = [
        ("Toronto - Ottawa", "05/12/2024", "Completed", "$50.00")
    ]
    
    var body: some View {
        List(completedTrips, id: \.0) { trip in
            VStack(alignment: .leading, spacing: 5) {
                Text("Route: \(trip.0)")
                    .font(.headline)
                Text("Date: \(trip.1)")
                    .font(.subheadline)
                Text("Status: \(trip.2)")
                    .font(.subheadline)
                Text("Price: \(trip.3)")
                    .font(.subheadline)
            }
            .padding(.vertical, 5)
        }
        .listStyle(PlainListStyle())
    }
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView()
    }
}

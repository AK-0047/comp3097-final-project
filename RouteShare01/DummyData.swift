//
//  DummyData.swift
//  RouteShare01
//
//  Created by Anshul Dharmendra Kamboya on 2025-02-24.
//

import Foundation

struct Ride {
    let id: UUID
    let origin: String
    let destination: String
    let date: String
    let time: String
    let driverName: String
    let seatsAvailable: Int
}

struct UserProfile {
    let name: String
    let email: String
}

// Sample Data
let dummyRides = [
    Ride(id: UUID(), origin: "New York", destination: "Washington, D.C.", date: "2025-03-01", time: "10:00 AM", driverName: "Alice Smith", seatsAvailable: 2),
    Ride(id: UUID(), origin: "Los Angeles", destination: "San Francisco", date: "2025-03-02", time: "2:00 PM", driverName: "John Doe", seatsAvailable: 1),
    Ride(id: UUID(), origin: "Chicago", destination: "Detroit", date: "2025-03-03", time: "1:00 PM", driverName: "Jane Doe", seatsAvailable: 3)
]

let dummyUserProfile = UserProfile(name: "John Doe", email: "johndoe@example.com")

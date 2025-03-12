//import Foundation
//
//struct Ride: Identifiable, Codable {
//    let id: String
//    let origin: String
//    let destination: String
//    let date: Date
//    let price: Double
//    let seatsAvailable: Int
//    let driverID: String
//    let vehicleModel: String?
//    let vehiclePlate: String?
//    let driverLicense: String?
//    let contactNumber: String?
//    let additionalNotes: String?
//
//    // **Convert Firestore Data to Ride Model**
//    init?(id: String, data: [String: Any]) {
//        guard let origin = data["origin"] as? String,
//              let destination = data["destination"] as? String,
//              let timestamp = data["date"] as? TimeInterval,
//              let price = data["price"] as? Double,
//              let seatsAvailable = data["seatsAvailable"] as? Int,
//              let driverID = data["driverID"] as? String else { return nil }
//
//        self.id = id
//        self.origin = origin
//        self.destination = destination
//        self.date = Date(timeIntervalSince1970: timestamp)
//        self.price = price
//        self.seatsAvailable = seatsAvailable
//        self.driverID = driverID
//        self.vehicleModel = data["vehicleModel"] as? String
//        self.vehiclePlate = data["vehiclePlate"] as? String
//        self.driverLicense = data["driverLicense"] as? String
//        self.contactNumber = data["contactNumber"] as? String
//        self.additionalNotes = data["additionalNotes"] as? String
//    }
//
//    // **Convert Ride Model to Dictionary (For Firestore)**
//    var dictionary: [String: Any] {
//        return [
//            "id": id,
//            "origin": origin,
//            "destination": destination,
//            "date": date,
//            "price": price,
//            "seatsAvailable": seatsAvailable,
//            "driverID": driverID,
//            "vehicleModel": vehicleModel ?? "",
//            "vehiclePlate": vehiclePlate ?? "",
//            "driverLicense": driverLicense ?? "",
//            "contactNumber": contactNumber ?? "",
//            "additionalNotes": additionalNotes ?? ""
//        ]
//    }
//}


import FirebaseFirestore

struct Ride: Identifiable, Codable {
    let id: String
    let origin: String
    let destination: String
    let date: Date  // ✅ Ensure it is a Date type
    let price: Double
    let seatsAvailable: Int
    let vehicleModel: String
    let vehiclePlate: String
    let driverLicense: String
    let contactNumber: String
    let additionalNotes: String
    let driverID: String

    // **✅ Convert Firestore Data to Ride Model**
    init?(id: String, data: [String: Any]) {
        guard let origin = data["origin"] as? String,
              let destination = data["destination"] as? String,
              let price = data["price"] as? Double,
              let seatsAvailable = data["seatsAvailable"] as? Int,
              let vehicleModel = data["vehicleModel"] as? String,
              let vehiclePlate = data["vehiclePlate"] as? String,
              let driverLicense = data["driverLicense"] as? String,
              let contactNumber = data["contactNumber"] as? String,
              let additionalNotes = data["additionalNotes"] as? String,
              let driverID = data["driverID"] as? String,
              let timestamp = data["date"] as? Timestamp  // ✅ Ensure it's a Timestamp
        else { return nil }

        self.id = id
        self.origin = origin
        self.destination = destination
        self.date = timestamp.dateValue()  // ✅ Convert Timestamp to Date
        self.price = price
        self.seatsAvailable = seatsAvailable
        self.vehicleModel = vehicleModel
        self.vehiclePlate = vehiclePlate
        self.driverLicense = driverLicense
        self.contactNumber = contactNumber
        self.additionalNotes = additionalNotes
        self.driverID = driverID
    }

    // **✅ Convert to Firestore Dictionary**
    var dictionary: [String: Any] {
        return [
            "id": id,
            "origin": origin,
            "destination": destination,
            "date": Timestamp(date: date),  // ✅ Store as Timestamp
            "price": price,
            "seatsAvailable": seatsAvailable,
            "vehicleModel": vehicleModel,
            "vehiclePlate": vehiclePlate,
            "driverLicense": driverLicense,
            "contactNumber": contactNumber,
            "additionalNotes": additionalNotes,
            "driverID": driverID
        ]
    }
}

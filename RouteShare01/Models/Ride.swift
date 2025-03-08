import Foundation

struct Ride: Identifiable, Codable {
    let id: String
    let origin: String
    let destination: String
    let date: Date
    let price: Double
    let seatsAvailable: Int
    let driverID: String
    let vehicleModel: String?
    let vehiclePlate: String?
    let driverLicense: String?
    let contactNumber: String?
    let additionalNotes: String?

    // **Convert Firestore Data to Ride Model**
    init?(id: String, data: [String: Any]) {
        guard let origin = data["origin"] as? String,
              let destination = data["destination"] as? String,
              let timestamp = data["date"] as? TimeInterval,
              let price = data["price"] as? Double,
              let seatsAvailable = data["seatsAvailable"] as? Int,
              let driverID = data["driverID"] as? String else { return nil }

        self.id = id
        self.origin = origin
        self.destination = destination
        self.date = Date(timeIntervalSince1970: timestamp)
        self.price = price
        self.seatsAvailable = seatsAvailable
        self.driverID = driverID
        self.vehicleModel = data["vehicleModel"] as? String
        self.vehiclePlate = data["vehiclePlate"] as? String
        self.driverLicense = data["driverLicense"] as? String
        self.contactNumber = data["contactNumber"] as? String
        self.additionalNotes = data["additionalNotes"] as? String
    }

    // **Convert Ride Model to Dictionary (For Firestore)**
    var dictionary: [String: Any] {
        return [
            "id": id,
            "origin": origin,
            "destination": destination,
            "date": date,
            "price": price,
            "seatsAvailable": seatsAvailable,
            "driverID": driverID,
            "vehicleModel": vehicleModel ?? "",
            "vehiclePlate": vehiclePlate ?? "",
            "driverLicense": driverLicense ?? "",
            "contactNumber": contactNumber ?? "",
            "additionalNotes": additionalNotes ?? ""
        ]
    }
}

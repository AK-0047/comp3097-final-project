import Foundation

struct Ride: Identifiable, Codable {
    let id: String
    let origin: String
    let destination: String
    let date: Date
    let price: String
    let seatsAvailable: String
    let vehicleModel: String
    let vehiclePlate: String
    let driverLicense: String
    let contactNumber: String
    let additionalNotes: String
    let driverID: String  // Reference to the driver's user ID
    
    // **Convert Firestore Data to Ride Model**
    init?(id: String, data: [String: Any]) {
        guard let origin = data["origin"] as? String,
              let destination = data["destination"] as? String,
              let timestamp = data["date"] as? TimeInterval,  // Storing as timestamp
              let price = data["price"] as? String,
              let seatsAvailable = data["seatsAvailable"] as? String,
              let vehicleModel = data["vehicleModel"] as? String,
              let vehiclePlate = data["vehiclePlate"] as? String,
              let driverLicense = data["driverLicense"] as? String,
              let contactNumber = data["contactNumber"] as? String,
              let additionalNotes = data["additionalNotes"] as? String,
              let driverID = data["driverID"] as? String else { return nil }
        
        self.id = id
        self.origin = origin
        self.destination = destination
        self.date = Date(timeIntervalSince1970: timestamp)
        self.price = price
        self.seatsAvailable = seatsAvailable
        self.vehicleModel = vehicleModel
        self.vehiclePlate = vehiclePlate
        self.driverLicense = driverLicense
        self.contactNumber = contactNumber
        self.additionalNotes = additionalNotes
        self.driverID = driverID
    }
    
    // **Convert Ride Model to Dictionary (For Firestore)**
    var dictionary: [String: Any] {
        return [
            "id": id,
            "origin": origin,
            "destination": destination,
            "date": date.timeIntervalSince1970, // Convert Date to timestamp
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

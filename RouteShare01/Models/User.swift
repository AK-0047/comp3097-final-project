import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullName: String
    let email: String
    let contactNumber: String
    let createdAt: Date
    let driverLicense: String?
    let vehicleModel: String?
    let vehiclePlate: String?

    // **Convert Firestore Data to User Model**
    init?(id: String, data: [String: Any]) {
        guard let fullName = data["fullName"] as? String,
              let email = data["email"] as? String,
              let contactNumber = data["contactNumber"] as? String,
              let createdAtTimestamp = data["createdAt"] as? TimeInterval else { return nil }

        self.id = id
        self.fullName = fullName
        self.email = email
        self.contactNumber = contactNumber
        self.createdAt = Date(timeIntervalSince1970: createdAtTimestamp)
        self.driverLicense = data["driverLicense"] as? String
        self.vehicleModel = data["vehicleModel"] as? String
        self.vehiclePlate = data["vehiclePlate"] as? String
    }

    // **Convert User Model to Dictionary (For Firestore)**
    var dictionary: [String: Any] {
        return [
            "id": id,
            "fullName": fullName,
            "email": email,
            "contactNumber": contactNumber,
            "createdAt": createdAt.timeIntervalSince1970,
            "driverLicense": driverLicense ?? "",
            "vehicleModel": vehicleModel ?? "",
            "vehiclePlate": vehiclePlate ?? ""
        ]
    }
}

//import FirebaseFirestore
//import FirebaseAuth
//
//class FirestoreService {
//    
//    static let shared = FirestoreService()
//    private let db = Firestore.firestore()
//    
//    private init() {}
//
//    // **✅ Securely Save New User Data in Firestore ✅**
//    func saveUser(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
//        guard let currentUser = Auth.auth().currentUser else {
//            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
//            return
//        }
//
//        let userData: [String: Any] = [
//            "fullName": user.fullName,
//            "email": user.email,
//            "id": user.id,
//            "createdAt": Timestamp(date: Date())  // Storing user creation time
//        ]
//
//        db.collection("users").document(user.id).setData(userData, merge: true) { error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(()))
//            }
//        }
//    }
//
//    // **✅ Fetch User Data Securely ✅**
//    func fetchUser(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
//        guard let currentUser = Auth.auth().currentUser, currentUser.uid == userId else {
//            completion(.failure(NSError(domain: "Firestore", code: 403, userInfo: [NSLocalizedDescriptionKey: "Unauthorized access"])))
//            return
//        }
//
//        db.collection("users").document(userId).getDocument { document, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = document?.data(),
//                  let fullName = data["fullName"] as? String,
//                  let email = data["email"] as? String else {
//                completion(.failure(NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
//                return
//            }
//            
//            let user = User(id: userId, fullName: fullName, email: email)
//            completion(.success(user))
//        }
//    }
//
//    // **✅ Securely Add Ride to Firestore ✅**
//    func addRide(ride: Ride, completion: @escaping (Result<Void, Error>) -> Void) {
//        guard let userID = Auth.auth().currentUser?.uid else {
//            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
//            return
//        }
//
//        let rideData: [String: Any] = [
//            "id": ride.id,
//            "origin": ride.origin,
//            "destination": ride.destination,
//            "date": Timestamp(date: ride.date),
//            "price": ride.price,
//            "seatsAvailable": ride.seatsAvailable,
//            "vehicleModel": ride.vehicleModel,
//            "vehiclePlate": ride.vehiclePlate,
//            "driverLicense": ride.driverLicense,
//            "contactNumber": ride.contactNumber,
//            "additionalNotes": ride.additionalNotes,
//            "driverID": userID,
//            "postedAt": Timestamp(date: Date())  // Storing ride creation time
//        ]
//
//        db.collection("rides").document(ride.id).setData(rideData) { error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(()))
//            }
//        }
//    }
//    
//    // Fetch all rides from Firestore
//    func fetchAllRides(completion: @escaping (Result<[Ride], Error>) -> Void) {
//        db.collection("rides").getDocuments { snapshot, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let documents = snapshot?.documents else {
//                completion(.success([])) // Return empty array if no data
//                return
//            }
//            
//            let rides: [Ride] = documents.compactMap { doc in
//                let data = doc.data()
//                return Ride(id: doc.documentID, data: data) // Use Ride model init
//            }
//            
//            completion(.success(rides))
//        }
//    }
//
//
//    // **✅ Fetch Rides from Firestore ✅**
//    func fetchAvailableRides(completion: @escaping (Result<[Ride], Error>) -> Void) {
//        db.collection("rides").order(by: "date", descending: false).getDocuments { snapshot, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            let rides = snapshot?.documents.compactMap { doc -> Ride? in
//                let data = doc.data()
//                
//                guard let origin = data["origin"] as? String,
//                      let destination = data["destination"] as? String,
//                      let timestamp = data["date"] as? Timestamp,
//                      let price = data["price"] as? String,
//                      let seatsAvailable = data["seatsAvailable"] as? String,
//                      let vehicleModel = data["vehicleModel"] as? String,
//                      let vehiclePlate = data["vehiclePlate"] as? String,
//                      let driverLicense = data["driverLicense"] as? String,
//                      let contactNumber = data["contactNumber"] as? String,
//                      let additionalNotes = data["additionalNotes"] as? String,
//                      let driverID = data["driverID"] as? String else { return nil }
//
//                return Ride(
//                    id: doc.documentID,
//                    origin: origin,
//                    destination: destination,
//                    date: timestamp.dateValue(),
//                    price: price,
//                    seatsAvailable: seatsAvailable,
//                    vehicleModel: vehicleModel,
//                    vehiclePlate: vehiclePlate,
//                    driverLicense: driverLicense,
//                    contactNumber: contactNumber,
//                    additionalNotes: additionalNotes,
//                    driverID: driverID
//                )
//            } ?? []
//
//            completion(.success(rides))
//        }
//    }
//
//    // **✅ Delete Ride (Only by Owner) ✅**
//    func deleteRide(rideId: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        guard let userID = Auth.auth().currentUser?.uid else {
//            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
//            return
//        }
//
//        let rideRef = db.collection("rides").document(rideId)
//        rideRef.getDocument { document, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = document?.data(), let rideOwnerID = data["driverID"] as? String, rideOwnerID == userID else {
//                completion(.failure(NSError(domain: "", code: 403, userInfo: [NSLocalizedDescriptionKey: "Unauthorized deletion attempt"])))
//                return
//            }
//
//            rideRef.delete { error in
//                if let error = error {
//                    completion(.failure(error))
//                } else {
//                    completion(.success(()))
//                }
//            }
//        }
//    }
//}


import FirebaseFirestore
import FirebaseAuth

class FirestoreService {
    
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    
    private init() {}

    // **Save Ride to Firestore**
    func addRide(ride: Ride, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }

        var rideData = ride.dictionary
        rideData["driverID"] = userID // Ensure driverID is set correctly

        db.collection("rides").document(ride.id).setData(rideData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // **Fetch All Rides**
    func fetchAllRides(completion: @escaping (Result<[Ride], Error>) -> Void) {
        db.collection("rides").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([])) // No data case
                return
            }
            
            let rides: [Ride] = documents.compactMap { doc in
                let data = doc.data()
                return Ride(id: doc.documentID, data: data)
            }
            
            completion(.success(rides))
        }
    }
    
    // **Fetch Rides by User (For Profile Page)**
    func fetchUserRides(userID: String, completion: @escaping (Result<[Ride], Error>) -> Void) {
        db.collection("rides").whereField("driverID", isEqualTo: userID).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }

            let userRides: [Ride] = documents.compactMap { doc in
                let data = doc.data()
                return Ride(id: doc.documentID, data: data)
            }

            completion(.success(userRides))
        }
    }
}

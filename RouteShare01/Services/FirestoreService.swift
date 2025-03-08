import FirebaseFirestore
import FirebaseAuth

class FirestoreService {
    
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    
    private init() {}

    // **✅ Save User to Firestore**
    func saveUser(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        let userData = user.dictionary
        
        db.collection("users").document(user.id).setData(userData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // **✅ Fetch User from Firestore**
    func fetchUser(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = document?.data(),
                  let user = User(id: userId, data: data) else {
                completion(.failure(NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                return
            }

            completion(.success(user))
        }
    }
    
    // **✅ Delete User from Firestore**
    func deleteUser(userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let userRef = db.collection("users").document(userId)

        // **1️⃣ Delete user's data from Firestore**
        userRef.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(())) // Firestore user data deleted
            }
        }
    }
    

    // **✅ Save Ride to Firestore**
    func addRide(ride: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let rideID = ride["id"] as? String else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "No ID in ride dictionary"])))
            return
        }
        
        db.collection("rides").document(rideID).setData(ride) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
//    func addRide(ride: Ride, completion: @escaping (Result<Void, Error>) -> Void) {
//        guard let userID = Auth.auth().currentUser?.uid else {
//            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
//            return
//        }
//
//        var rideData = ride.dictionary
//        rideData["driverID"] = userID // Ensure driverID is set correctly
//
//        db.collection("rides").document(ride.id).setData(rideData) { error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(()))
//            }
//        }
//    }

    // **✅ Fetch All Rides**
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
    
    func fetchRidesMatching(origin: String, destination: String, date: Date, completion: @escaping (Result<[Ride], Error>) -> Void) {
            db.collection("rides")
                .whereField("origin", isEqualTo: origin)
                .whereField("destination", isEqualTo: destination)
                .getDocuments { snapshot, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }

                    guard let documents = snapshot?.documents else {
                        completion(.success([])) // No rides found
                        return
                    }

                    let rides: [Ride] = documents.compactMap { doc in
                        let data = doc.data()
                        let ride = Ride(id: doc.documentID, data: data)

                        // **Filter by Date**
                        if let ride = ride, Calendar.current.isDate(ride.date, inSameDayAs: date) {
                            return ride
                        }
                        return nil
                    }

                    completion(.success(rides))
                }
        }

    
    // **✅ Fetch Rides by User (For Profile Page)**
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

    // **✅ Update Ride Details**
    func updateRide(rideID: String, updatedData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("rides").document(rideID).updateData(updatedData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // **✅ Delete Ride**
    func deleteRide(rideID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("rides").document(rideID).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

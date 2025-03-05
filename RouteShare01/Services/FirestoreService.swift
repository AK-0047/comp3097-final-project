import FirebaseFirestore

class FirestoreService {
    
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // Store new user data in Firestore
    func saveUser(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        let userData: [String: Any] = [
            "fullName": user.fullName,
            "email": user.email,
            "id": user.id
        ]
        
        db.collection("users").document(user.id).setData(userData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Fetch user data from Firestore
    func fetchUser(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = document?.data(),
                  let fullName = data["fullName"] as? String,
                  let email = data["email"] as? String else {
                completion(.failure(NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                return
            }
            
            let user = User(id: userId, fullName: fullName, email: email)
            completion(.success(user))
        }
    }
}

import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthService {
    
    static let shared = FirebaseAuthService()
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    private init() {}

    // **Sign Up New User & Save to Firestore**
    func signUpUser(fullName: String, email: String, password: String, contactNumber: String, driverLicense: String?, vehicleModel: String?, vehiclePlate: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let userId = result?.user.uid else {
                completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
                return
            }
            
            // **Prepare User Data for Firestore**
            let userData: [String: Any] = [
                "id": userId,
                "fullName": fullName,
                "email": email,
                "contactNumber": contactNumber,
                "driverLicense": driverLicense ?? "",
                "vehicleModel": vehicleModel ?? "",
                "vehiclePlate": vehiclePlate ?? "",
                "createdAt": Timestamp(date: Date()) // Track account creation date
            ]
            
            // **Save User Data to Firestore**
            self.db.collection("users").document(userId).setData(userData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }

    // **Login User**
    func loginUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let userId = result?.user.uid else {
                completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
                return
            }
            
            // **Fetch User Data from Firestore**
            self.db.collection("users").document(userId).getDocument { document, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = document?.data() else {
                    completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "User data not found"])))
                    return
                }
                
                if let user = User(id: userId, data: data) {
                    completion(.success(user))
                } else {
                    completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid user data"])))
                }
            }
        }
    }

    // **Logout User**
    func logoutUser(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try auth.signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    // **Reset Password**
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

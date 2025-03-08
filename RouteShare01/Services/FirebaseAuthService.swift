import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthService {
    
    static let shared = FirebaseAuthService()
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    private init() {}

    // **✅ Sign Up User**
    func signUpUser(
        fullName: String,
        email: String,
        password: String,
        contactNumber: String,
        driverLicense: String?,
        vehicleModel: String?,
        vehiclePlate: String?,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let userId = result?.user.uid else {
                completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
                return
            }

            // Create user data dictionary
            let userData: [String: Any] = [
                "fullName": fullName,
                "email": email,
                "contactNumber": contactNumber,
                "createdAt": Date().timeIntervalSince1970,
                "driverLicense": driverLicense ?? "",
                "vehicleModel": vehicleModel ?? "",
                "vehiclePlate": vehiclePlate ?? ""
            ]

            // **Save User Data to Firestore**
            self.db.collection("users").document(userId).setData(userData) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                // Create user object with the same data
                guard let newUser = User(id: userId, data: userData) else {
                    completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create user object"])))
                    return
                }
                
                completion(.success(newUser))
            }
        }
    }

    // **✅ 2. Login User & Fetch Data**
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
                
                guard let document = document, document.exists, let data = document.data() else {
                    completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "User data not found"])))
                    return
                }
                
                guard let user = User(id: userId, data: data) else {
                    completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse user data"])))
                    return
                }

                completion(.success(user))
            }
        }
    }


    // **✅ 3. Logout User**
    func logoutUser(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try auth.signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    // **✅ 4. Reset Password**
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // **✅ 5. Update User Profile**
    func updateUserProfile(userId: String, updatedData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(userId).updateData(updatedData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // **✅ 6. Delete User Account**
    func deleteUserAccount(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = auth.currentUser else {
            completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        let userId = user.uid
        
        // **Delete from Firestore**
        db.collection("users").document(userId).delete { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // **Delete from Firebase Authentication**
            user.delete { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }

    // **✅ 7. Reauthenticate User (Before Sensitive Actions)**
    func reauthenticateUser(currentPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = auth.currentUser, let email = user.email else {
            completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // **✅ 8. Change Password**
    func changePassword(newPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = auth.currentUser else {
            completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        user.updatePassword(to: newPassword) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

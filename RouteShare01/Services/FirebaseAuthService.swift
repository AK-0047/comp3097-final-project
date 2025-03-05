import FirebaseAuth

class FirebaseAuthService {
    
    static let shared = FirebaseAuthService()
    
    private init() {}

    // Sign up a new user
    func signUp(fullName: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = authResult?.user else {
                completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                return
            }
            
            let user = User(id: firebaseUser.uid, fullName: fullName, email: email)
            completion(.success(user))
        }
    }

    // Log in an existing user
    func logIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = authResult?.user else {
                completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                return
            }
            
            let user = User(id: firebaseUser.uid, fullName: firebaseUser.displayName ?? "", email: email)
            completion(.success(user))
        }
    }
    
    // Log out the user
    func logOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}

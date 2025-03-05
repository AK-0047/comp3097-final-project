//import SwiftUI
//
//@main
//struct RouteShare01App: App {
//    var body: some Scene {
//        WindowGroup {
//            LoginView()
//        }
//    }
//}


import SwiftUI
import Firebase

@main
struct RouteShare01App: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}

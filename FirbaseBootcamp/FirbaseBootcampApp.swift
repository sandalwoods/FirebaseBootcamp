//
//  FirbaseBootcampApp.swift
//  FirbaseBootcamp
//
//  Created by kevin on 2023/5/9.
//

import SwiftUI
import Firebase

@main
struct FirbaseBootcampApp: App {
    
    init() {
        FirebaseApp.configure()
        print("Firebase configured")
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

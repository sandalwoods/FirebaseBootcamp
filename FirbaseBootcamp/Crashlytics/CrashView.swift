//
//  CrashView.swift
//  FirbaseBootcamp
//
//  Created by kevin on 2023/5/17.
//

import SwiftUI
import FirebaseCrashlytics

final class CrashManager {
    static let shared = CrashManager()
    private init() { }
    
    func setUserId(userId: String) {
        Crashlytics.crashlytics().setUserID(userId)
    }
    
    private func setValue(value: String, key: String) {
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }
    
    func setIsPremiumValue(isPremium: Bool) {
        setValue(value: isPremium.description.lowercased(), key: "user_is_premium")
    }
    
    func addLog(msg: String) {
        Crashlytics.crashlytics().log(msg)
    }
    
    func sendNonFatal(error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
}

struct CrashView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3).ignoresSafeArea()
            
            VStack(spacing: 40) {
                Button("click me 1") {
                    CrashManager.shared.addLog(msg: "button_1_clicked")
                    
                    
                    
                    let myString: String? = nil
                    
                    guard let myString else {
                        CrashManager.shared.sendNonFatal(error: URLError(.badURL))
                        return
                    }
                    
                    let string2 = myString
                }
                
                Button("click me 2") {
                    CrashManager.shared.addLog(msg: "button_2_clicked")
                    fatalError("This is fatal crash")
                }
                
                Button("click me 3") {
                    CrashManager.shared.addLog(msg: "button_3_clicked")
                    let array: [String] = []
                    let item = array[0]
                }
            }
        }
        .onAppear {
            CrashManager.shared.setUserId(userId: "ABC123")
            CrashManager.shared.setIsPremiumValue(isPremium: true)
            CrashManager.shared.addLog(msg: "crash_view_appear")
            CrashManager.shared.addLog(msg: "Crash view appear on user screen")
        }
    }
}

struct CrashView_Previews: PreviewProvider {
    static var previews: some View {
        CrashView()
    }
}

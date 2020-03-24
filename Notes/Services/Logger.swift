//
//  Logger.swift
//  Notes
//
//  Created by Oleh Mykytyn on 23.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import Foundation
import Firebase

final class Logger {
    static let shared = Logger()

    private let userDefaults = UserDefaults.standard
    private let loginStatusKey = "loginStatus.Key"
    
    var loginStatus: Bool {
        get {userDefaults.bool(forKey: loginStatusKey)}
        set {userDefaults.set(newValue, forKey: loginStatusKey)}
    }
    
    func getUser() -> User? {
        guard let user = Auth.auth().currentUser else { return nil }
        
        return User(displayName: user.displayName,
                    email: user.email,
                    phoneNumber: user.phoneNumber,
                    photoURL: user.photoURL,
                    uid: user.uid)
    }
    
    func logOut(completion: (Error?) -> ()) {
        do {
            try Auth.auth().signOut()
            Logger.shared.loginStatus = true
            completion(nil)
        } catch(let error) {
            completion(error)
        }
    }
}

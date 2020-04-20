//
//  Logger.swift
//  Notes
//
//  Created by Oleh Mykytyn on 23.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import Foundation
import Firebase

final class UserManager {
    static let shared = UserManager()

    private let userDefaults = UserDefaults.standard
    private let loginStatusKey = "loginStatus.Key"
    private var profileImageDataKey = "profileImageData.Key"

    var loginStatus: Bool {
        get {userDefaults.bool(forKey: loginStatusKey)}
        set {userDefaults.set(newValue, forKey: loginStatusKey)}
    }
    
    var profileImageData: Data? {
        get {userDefaults.data(forKey: profileImageDataKey)}
        set {userDefaults.set(newValue, forKey: profileImageDataKey)}
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
            UserManager.shared.loginStatus = false
            profileImageData = nil
            completion(nil)
        } catch(let error) {
            completion(error)
        }
    }
}

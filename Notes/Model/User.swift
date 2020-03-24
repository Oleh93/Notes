//
//  User.swift
//  Notes
//
//  Created by Oleh Mykytyn on 23.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import Foundation

class User {
    var displayName: String?
    var email: String?
    var phoneNumber: String?
    var photoURL: URL?
    var uid: String?
    
    init(displayName: String?,  email: String?, phoneNumber: String?, photoURL: URL?, uid: String?) {
        self.displayName = displayName
        self.email = email
        self.phoneNumber = phoneNumber
        self.photoURL = photoURL
        self.uid = uid
    }
}

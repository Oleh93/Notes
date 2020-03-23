//
//  Logger.swift
//  Notes
//
//  Created by Oleh Mykytyn on 23.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import Foundation


final class Logger {
    static let shared = Logger()

    private let userDefaults = UserDefaults.standard
    
    private let loginStatusKey = "loginStatus.Key"

    var loginStatus: Bool {
        get {userDefaults.bool(forKey: loginStatusKey)}
        set {userDefaults.set(newValue, forKey: loginStatusKey)}
    }
}

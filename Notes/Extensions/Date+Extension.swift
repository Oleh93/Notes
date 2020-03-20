//
//  Date+Extension.swift
//  Notes
//
//  Created by Oleh Mykytyn on 20.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import Foundation

extension Date {
    static func currentDate() -> String {
        let currentDateTime = Date()
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        
        let dateTime = formatter.string(from: currentDateTime)
        
        return dateTime
    }
}

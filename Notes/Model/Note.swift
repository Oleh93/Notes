//
//  Note.swift
//  Notes
//
//  Created by Oleh Mykytyn on 20.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import Foundation

public enum NoteState {
    case all
    case favourite
    case deleted
}

class Note: Identifiable {
    let id = UUID()
    let title: String
    let text: String
    let isFavorite: Bool
    var isDeleted: Bool
    let creationDate: String
    
    init(title: String, text: String, isFavorite: Bool, isDeleted: Bool) {
        self.title = title
        self.text = text
        self.isFavorite = isFavorite
        self.isDeleted = isDeleted
        self.creationDate = Date.currentDate()
    }
}

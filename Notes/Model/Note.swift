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

struct Note: Identifiable {
    let id = UUID()
    var title: String
    var text: String
    var isFavorite: Bool
    var isDeleted: Bool
    var creationDate: String
    
    init(title: String, text: String, isFavorite: Bool, isDeleted: Bool) {
        self.title = title
        self.text = text
        self.isFavorite = isFavorite
        self.isDeleted = isDeleted
        self.creationDate = Date.currentDate()
    }
}

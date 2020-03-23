//
//  NoteManager.swift
//  Notes
//
//  Created by Oleh Mykytyn on 22.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import Foundation
import SwiftUI

class NoteManager: ObservableObject {
    @Published var notes: [Note] = [
        Note(title: "Title 1", text: "Text 1", isFavorite: true, isDeleted: false),
        Note(title: "Title 2", text: "Text 2", isFavorite: false, isDeleted: false),
        Note(title: "Title 3", text: "Text 3", isFavorite: true, isDeleted: false)
    ]
    
    @Published var deletedNotes: [Note] = []
    
    func delete(note: Note) {
        guard let index = notes.firstIndex(where: { (temp) -> Bool in
            temp === note
        }) else { return }
        
        deletedNotes.append(note)
        notes.remove(at: index)
        note.isDeleted = true
        print(notes)
    }
    
    func deleteFromDeleted(note: Note) {
        guard let index = deletedNotes.firstIndex(where: { (temp) -> Bool in
            temp === note
        }) else { return }
        
        deletedNotes.remove(at: index)
        note.isDeleted = true
    }
    
    func filtered(by state: NoteState) -> [Note] {
        var filteredNotes: [Note] = []

        switch state {
        case .all:
            filteredNotes = notes
        case .favourite:
            filteredNotes = notes.filter({ (note) -> Bool in
                note.isFavorite && !note.isDeleted
            })
        case .deleted:
            filteredNotes = deletedNotes
        }
        
        return filteredNotes
    }
}

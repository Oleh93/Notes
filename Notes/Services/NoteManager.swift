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
    @Published var favoriteNotes: [Note] = []

    func add(note: Note) { notes.append(note) }

    func delete(at offset: IndexSet, force: Bool) {
        if force {
            for index in offset {
                deletedNotes.remove(at: index)
            }
        }
        else {
            for index in offset {
                var note = notes.remove(at: index)
                note.isDeleted = true
                deletedNotes.append(note)
            }
        }
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
//            filteredNotes = favoriteNotes
        case .deleted:
            filteredNotes = deletedNotes
        }

        return filteredNotes
    }
    
    func change(old: Note, new: Note) {
        if old.isDeleted {
            guard let index = deletedNotes.firstIndex(where: { (note) -> Bool in
                note.id == old.id
            }) else { return }
            deletedNotes[index] = new
            print(old)
            print(index)
            print(deletedNotes)
        }
        else if !old.isDeleted {
            guard let index = notes.firstIndex(where: { (note) -> Bool in
                note.id == old.id
            }) else { return }
            notes[index] = new
        }
    }
}

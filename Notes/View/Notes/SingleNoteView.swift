//
//  DetailedNote.swift
//  Notes
//
//  Created by Oleh Mykytyn on 22.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import Foundation
import SwiftUI

struct SingleNoteView: View {
    var noteManager: NoteManager
    
    @State var note: Note

    @Environment(\.presentationMode) var presentationMode

    @State var text: String = ""
    @State var title: String = ""
    @State var isFavorite: Bool = false
    @State var isDeleted: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter title here", text: $title)
                Toggle(isOn: $isFavorite) { Text("Favorite").foregroundColor(.gray) }
                TextView(text: $text)
            }.onAppear {
                self.title = self.note.title
                self.text = self.note.text
                self.isFavorite = self.note.isFavorite
                self.isDeleted = self.note.isDeleted
            }
            
        }
        .navigationBarTitle("Note")
        .onDisappear {
            print("Back clicked")
            self.note.text = self.text
            self.note.title = self.title
            self.note.isFavorite = self.isFavorite
            self.note.isDeleted = self.isDeleted
            
            self.noteManager.change(old: self.note, new: Note(title: self.title, text: self.text, isFavorite: self.isFavorite, isDeleted: self.isDeleted))
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

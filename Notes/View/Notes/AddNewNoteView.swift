//
//  AddNewNoteView.swift
//  Notes
//
//  Created by Oleh Mykytyn on 23.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import Foundation
import SwiftUI

struct AddNewNoteView: View {
    let noteManager: NoteManager
    
    @State var title        = ""
    @State var isFavorite   = false
    @State var text         = ""
    @State var isDeleted    = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button(action: {
                    let note = Note(
                        title: self.title,
                        text: self.text,
                        isFavorite: self.isFavorite,
                        isDeleted: self.isDeleted
                    )
                    
                    self.noteManager.notes.append(note)
                    
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done")
                }
                .disabled(title.isEmpty && text.isEmpty)
            }
            
            TextField("Enter title here", text: $title)
            Toggle(isOn: $isFavorite) { Text("Favorite") }
//            TextField("Enter text here", text: $text)
            TextView(text: $text)
        }
        .padding()
    }
}

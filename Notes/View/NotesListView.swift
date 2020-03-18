//
//  NotesListView.swift
//  Notes
//
//  Created by Oleh Mykytyn on 18.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import SwiftUI

class Note: Identifiable {
    let id = UUID()
    let title: String
    let text: String
    let isFavorite: Bool
    var isDeleted: Bool
    
    init(title: String, text: String, isFavorite: Bool, isDeleted: Bool) {
        self.title = title
        self.text = text
        self.isFavorite = isFavorite
        self.isDeleted = isDeleted
    }
}

enum NoteState {
    case all
    case favourite
    case deleted
}
    
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
    
    func getFiltered(by state: NoteState) -> [Note] {
        var filteredNotes: [Note] = []

        switch state {
        case .all:
            return notes
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

struct NoteRowView: View {
    let note: Note
    
    var body: some View {
        HStack {
            Text(note.title)
            
            Spacer()
                .frame(width: 50.0)
            
            Text(note.text)
            
            Spacer()
            
            if note.isFavorite {
                Image(systemName: "star.fill")
            }
        }
    }
}

struct AddNewNoteView: View {
    let noteManager: NoteManager
    
    @State var title        = ""
    @State var isFavorite   = false
    @State var text         = ""
    @State var isDeleted   = false
    
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
                        .foregroundColor(Color.green)
                }
                .disabled(title.isEmpty && text.isEmpty)
            }
            
            TextField("Enter title here", text: $title)
            Toggle(isOn: $isFavorite) { Text("Favorite") }
            TextField("Enter text here", text: $text)
        }
        .padding()
    }
}

struct NotesListView: View {
    @ObservedObject var noteManager: NoteManager
    @State private var shouldShowSheet = false
    
    @State private var selectorIndex = 0
    @State private var statesStr = ["All", "Favourites", "Deleted"]
    @State private var states = [NoteState.all, NoteState.favourite, NoteState.deleted]

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Picker("States", selection: $selectorIndex) {
                        ForEach(0 ..< statesStr.count) { index in
                            Text(self.statesStr[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Text("Selected value is: \(statesStr[selectorIndex])").padding()
                }
                
                List {
                    ForEach(noteManager.getFiltered(by: states[selectorIndex])) { note in
                        NoteRowView(note: note)
                    }
                    .onMove(perform: move(from:to:))
                    .onDelete(perform: delete(for:))
                }
                .navigationBarItems(
                    trailing: HStack {
                        Button(
                            action: {
                                self.shouldShowSheet.toggle()
                            },
                            label: {
                                Text("Add")
                            }
                        )
                            .sheet(isPresented: $shouldShowSheet) {
                            AddNewNoteView(noteManager: self.noteManager)
                        }
                        
                        Spacer()
                            .frame(width: 25.0)
                        
                        EditButton()
                    }
                )
                .navigationBarTitle("Notes")
            }
            .padding()
        }
    }
    
    func delete(for offset: IndexSet) {
        let fromDeleted = true ? selectorIndex == 2: false
        let notesToDelete = noteManager.getFiltered(by: states[selectorIndex])
        
        for i in offset {
            if fromDeleted {
                noteManager.deleteFromDeleted(note: notesToDelete[i])
            } else {
                noteManager.delete(note: notesToDelete[i])
            }
        }
//        noteManager.notes.remove(atOffsets: offset)
    }
    
    func move(from offset: IndexSet, to index: Int) {
        noteManager.notes.move(fromOffsets: offset, toOffset: index)
    }
}

struct NotesLisView_Previews: PreviewProvider {
    static var previews: some View {
        NotesListView(noteManager: NoteManager())
    }
}


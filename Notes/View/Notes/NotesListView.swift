//
//  NotesListView.swift
//  Notes
//
//  Created by Oleh Mykytyn on 18.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import SwiftUI

struct NoteRowView: View {
    let note: Note
    
    var body: some View {
        VStack {
            HStack {
                Text(note.title)
                
                Spacer()
                    .frame(width: 50.0)
                
                Text(note.text)
                    .lineLimit(1)
                
                Spacer()

                if note.isFavorite {
                    Image(systemName: "star.fill")
                }
            }
            
            Spacer()
            
            Text(note.creationDate)
                .fontWeight(.light)
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct NotesListView: View {
    @ObservedObject var noteManager: NoteManager
    
    @State var loginStatus = Logger.shared.loginStatus
    @State private var shouldShowProfileView = false
    @State private var shouldShowSheet       = false

    @State private var selectorIndex = 0
    @State private var statesStr     = ["All", "Favourites", "Deleted"]
    @State private var states        = [NoteState.all, NoteState.favourite, NoteState.deleted]
    
    var body: some View {
        VStack {
            if !loginStatus {
                AuthView()
            } else {
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
                            ForEach(noteManager.filtered(by: states[selectorIndex])) { note in
                                NavigationLink(destination: SingledNoteView(note: note)) {
                                    NoteRowView(note: note)
                                }
                            }
                            .onMove(perform: move(from:to:))
                            .onDelete(perform: delete(for:))
                        }
                        .navigationBarItems(
                            leading: HStack {
                                Button(
                                    action: {
                                        self.shouldShowProfileView.toggle()
                                    },
                                    label: {
                                        Image(systemName: "person.crop.circle")
                                    }
                                )
                                .sheet(isPresented: $shouldShowProfileView) {
                                    ProfileView()
                                }
                            },
                            trailing: HStack {
                                Button(
                                    action: {
                                        self.shouldShowSheet.toggle()
                                    },
                                    label: {
                                        Image(systemName: "plus.circle")
                                    }
                                )
                                .sheet(isPresented: $shouldShowSheet) {
                                        AddNewNoteView(noteManager: self.noteManager)
                                }
                                
                                Spacer(minLength: 15)
                                EditButton()
                            }
                        
                        )
                        .navigationBarTitle("Notes")
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in
                self.loginStatus = Logger.shared.loginStatus
            }
        }
    }

    func delete(for offset: IndexSet) {
        let fromDeleted = true ? selectorIndex == 2: false

        let notesToDelete = noteManager.filtered(by: states[selectorIndex])

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


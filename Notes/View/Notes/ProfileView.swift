//
//  ProfileView.swift
//  Notes
//
//  Created by Oleh Mykytyn on 24.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

import Firebase
struct DropDown: View {
    @State var expand = false
    var noteManager: NoteManager

    var body: some View {
        VStack {
            HStack {
                Text("Notes info")
                Image(systemName: expand ? "chevron.up": "chevron.down")
                    .resizable().frame(width: 13, height: 6)
            }
            .onTapGesture {
                self.expand.toggle()
            }
            
            if expand {
                Button(action: {
                    
                }) {
                    VStack(alignment: .leading) {
                        Text("Total: \(noteManager.filtered(by: .deleted).count + noteManager.filtered(by: .all).count)")
                        Text("Deleted: \(noteManager.filtered(by: .deleted).count)")
                        Text("Favorite: \(noteManager.filtered(by: .favourite).count)")
                    }
                    .foregroundColor(.black)
                }
            }
        }
    .padding()
    .cornerRadius(20)
    .animation(.spring())
    }
}

struct ProfileView: View {
    var noteManager: NoteManager
    
    @State var showingImagePicker = false
    @State var inputImage: UIImage = {
        guard let data = UserManager.shared.profileImageData else { return UIImage() }
        return UIImage(data: data) ?? UIImage()
    }()
            
    @State var displayName: String = UserManager.shared.getUser()?.displayName ?? ""
    @State var email: String = UserManager.shared.getUser()?.email ?? ""
    @State var phoneNumber: String = UserManager.shared.getUser()?.phoneNumber ?? ""
    var photoURL = UserManager.shared.getUser()?.photoURL
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
                VStack {
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Cancel")
                        }
                            .padding()
                        
                        Spacer()
                        
                        Button(action: {
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.displayName = self.displayName
                            changeRequest?.commitChanges { (error) in
                            }
                            if self.inputImage != UIImage() {
                                UserManager.shared.profileImageData = self.inputImage.pngData()
                            }
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Save")
                        }
                            .padding()
                    }
                        
                        
                    createImageView(fromUrl: (inputImage == UIImage()) ? true: false)
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 10)
                    .onTapGesture {
                        self.showingImagePicker = true
                    }

                    TextField("Enter user name here", text: $displayName)
                        .font(.title)
                        .multilineTextAlignment(.center)
                
                            Spacer()
                                .frame(height: 50)
                    
                    Text(email)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        
                    DropDown(noteManager: noteManager)

                    Spacer()

                    Button(action: {
                        UserManager.shared.logOut { (error) in
                            if let error = error {
                                print("Error while logOut:", error)
                            } else {
                                UserDefaults.resetStandardUserDefaults()
                                self.presentationMode.wrappedValue.dismiss()
                                print("logOut success")
                            }
                        }
                    }) {
                        Text("Log Out")
                            .foregroundColor(Color.red)
                    }
                        .frame(alignment: .center)
                }.sheet(isPresented: $showingImagePicker, onDismiss: {
                   
                }
                ) {
                    ImagePicker(image: self.$inputImage)
        }
    }

    func createImageView(fromUrl: Bool) -> AnyView? {
        if fromUrl {
            if let url = photoURL {
                return AnyView(WebImage(url: URL(string: url.absoluteString), options: [.progressiveLoad])
                    .resizable()
                    .indicator(.progress)
                )
            } else {
                return AnyView(Image(systemName: "person.circle"))
            }
        } else {
            return AnyView(
             Image(uiImage: inputImage)
             .resizable()
            )
        }
    }
}

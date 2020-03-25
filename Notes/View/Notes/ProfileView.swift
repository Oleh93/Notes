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

struct ProfileView: View {
    @State var userName: String = Logger.shared.getUser()?.displayName ?? ""
    @State var email: String = Logger.shared.getUser()?.email ?? ""
    @State var phoneNumber: String = Logger.shared.getUser()?.phoneNumber ?? ""
    var photoURL = Logger.shared.getUser()?.photoURL
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
                VStack {
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Cancel")
                        }
                        
                        Spacer()
                    }

                    createImageView()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(radius: 10)

                    TextField("Enter user name here", text: $userName)
                        .font(.title)
                        .multilineTextAlignment(.center)
                
                            Spacer()
                                .frame(height: 50)
                
                    Text("Contact information")
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.gray)
                    
                    TextField("Enter email here", text: $email)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                    
                    TextField("Enter phone number here", text: $phoneNumber)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        
                    Button(action: {
                        Logger.shared.logOut { (error) in
                            if let error = error {
                                print("Error while logOut:", error)
                            } else {
                                print("logOut success")
                            }
                        }
                    }) {
                        Text("Log Out")
                            .foregroundColor(Color.red)
                    }
                        .frame(alignment: .center)
            }
    }
    
    func createImageView() -> AnyView {
        if let url = photoURL {
            return AnyView(WebImage(url: URL(string: url.absoluteString), options: [.progressiveLoad])
                .resizable()
                .indicator(.progress)
            )
        } else {
            return AnyView(
                Image(systemName: "person.crop.circle")
                .resizable()
            )
        }
    }
}

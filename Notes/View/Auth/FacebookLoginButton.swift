//
//  Auth.swift
//  Notes
//
//  Created by Oleh Mykytyn on 21.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import SwiftUI
import FBSDKLoginKit
import Firebase

struct FacebookLoginButton: UIViewRepresentable {
    
    func makeCoordinator() -> FacebookLoginButton.Coordinator {
        return FacebookLoginButton.Coordinator()
    }
    
    class Coordinator: NSObject, LoginButtonDelegate {
        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let token = AccessToken.current else {return}
            let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                print("Facebook Signed In")
                Logger.shared.loginStatus = true
                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
            }
        }
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            try! Auth.auth().signOut()
            Logger.shared.loginStatus = false
            NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
        }
    }
    
    func makeUIView(context: UIViewRepresentableContext<FacebookLoginButton>) -> FBLoginButton {
        let view = FBLoginButton()
        //        view.permissions = ["email"]
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: FBLoginButton, context: UIViewRepresentableContext<FacebookLoginButton>) { }
}

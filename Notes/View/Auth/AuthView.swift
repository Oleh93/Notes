//
//  AuthView.swift
//  Notes
//
//  Created by Oleh Mykytyn on 23.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import Foundation
import SwiftUI

struct AuthView: View {
    var body: some View {
        VStack {
            Text("Sing In")
                .font(.largeTitle)
            
            FacebookLoginButton()
                .frame(width: 200, height: 50, alignment: .center)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

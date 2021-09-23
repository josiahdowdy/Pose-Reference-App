//
//  SignIn.swift
//  pose-reference
//
//  Created by jo on 2021-01-19.
//

import Foundation
import SwiftUI
import AuthenticationServices


struct SignIn: View {
    
var body: some View {
    
SignInWithAppleView()
            .frame(width: 200, height: 50)
    }
}








struct SignInWithAppleView: UIViewRepresentable {
func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton()
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    }
}

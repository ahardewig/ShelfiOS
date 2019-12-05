//
//  WelcomeView.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/14/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    
    @State var isRegistering: Bool = false;
    @State var isForgotPassword: Bool = false;
    
    var body: some View {
        
        Group() {
        Group() {
            if (isRegistering) {
                RegisterView(isRegistering: $isRegistering, isForgotPassword: $isForgotPassword)
            }
            else if (!isRegistering && !isForgotPassword) {
                LoginView(isRegistering: $isRegistering, isForgotPassword: $isForgotPassword)
            }
        }
        
        Group() {
            if (isForgotPassword) {
                ForgotPasswordView(isRegistering: $isRegistering, isForgotPassword: $isForgotPassword)
            }
        }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

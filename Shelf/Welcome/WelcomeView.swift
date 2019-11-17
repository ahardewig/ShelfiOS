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
            if (isRegistering && !isForgotPassword) {
                RegisterView(isRegistering: $isRegistering, isForgotPassword: $isForgotPassword)
            }
            else if (isForgotPassword && !isRegistering) {
                ForgotPasswordView(isRegistering: $isRegistering, isForgotPassword: $isForgotPassword)
            }
            else {
                LoginView(isRegistering: $isRegistering, isForgotPassword: $isForgotPassword)
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

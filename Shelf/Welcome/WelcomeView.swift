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
    var body: some View {
        
        Group() {
            if (isRegistering) {
                RegisterView(isRegistering: $isRegistering)
            }
            else {
                LoginView(isRegistering: $isRegistering)
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

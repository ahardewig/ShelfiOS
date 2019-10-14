//
//  ContentView.swift
//  Shelf
//
//  Created by Alex Hardewig on 9/21/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @State private var selection = 0
    @ObservedObject var user: User = User.currentUser;
    @EnvironmentObject var errorHandler: ErrorHandler
    
    var body: some View {
        //needed bc the Swift compiler is wack. REALLY solid stack
        //overflow post:
        //https://stackoverflow.com/questions/56517610/conditionally-use-view-in-swiftui
        Group() {
            
            if (!user.isLoggedIn) {
               //LoginView()
                WelcomeView()
            } else {
               TabRowView()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ErrorHandler.errorHandler)
    }
}



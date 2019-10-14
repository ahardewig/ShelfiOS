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
 
    var body: some View {
        TabView {
            NavigationView { HomeView() }
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Home")
                }.tag(0)

            NavigationView { Text("Hello!") }
                .tabItem {
                    Image(systemName: "flame.fill")
                    Text("My Shelf")
                }.tag(1)

            NavigationView { Text("Hi again!") }
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Find Friends")
                }.tag(2)

            NavigationView { Text("Coming soon?") }
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                    Text("Log Out!")
                }.tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            ContentView()
    }
}



//
//  TabRowView.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/13/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI

struct TabRowView: View {
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Karla-Bold", size: 32)!]
    }
    var body: some View {
        TabView() {
            NavigationView { HomeView() }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }.tag(0)

            NavigationView { ProfileView(username: User.currentUser.getUsername()) }
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("My Shelf")
                }.tag(1)

            
            
            NavigationView { AllMessagesView() }
            .tabItem {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                Text("Messages")
            }.tag(2)
            
            NavigationView { SearchView() }
            .tabItem {
                Image(systemName: "magnifyingglass.circle.fill")
                Text("Search")
            }.tag(3)
            
//            NavigationLink(destination: AllMessagesView()) {
//                Text("Go to messages")
//            }
            NavigationView { FindFriendView() }
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Users")
                }.tag(4)
        }
    }
}

struct TabRowView_Previews: PreviewProvider {
    static var previews: some View {
        TabRowView()
    }
}

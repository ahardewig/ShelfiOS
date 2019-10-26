//
//  TabRowView.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/13/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI

struct TabRowView: View {
    var body: some View {
        TabView {
            NavigationView { HomeView() }
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Home")
                }.tag(0)

            NavigationView { ProfileView(username: User.currentUser.getUsername()) }
                .tabItem {
                    Image(systemName: "flame.fill")
                    Text("My Shelf")
                }.tag(1)

            NavigationView { NotificationsView() }
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Notifications")
                }.tag(2)

            NavigationView { SearchView() }
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                    Text("Search")
                }.tag(3)
            
            NavigationView { FindFriendView() }
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
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

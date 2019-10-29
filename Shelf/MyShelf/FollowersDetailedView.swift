//
//  FollowersDetailedView.swift
//  Shelf
//
//  Created by Zach Johnson on 10/28/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI

struct FollowersDetailedView: View {
    @ObservedObject var profile: User
    
    var body: some View {
        VStack(alignment: .leading){
            
            kHeader(text: "Followers")
            ScrollView(.horizontal, content: {
                HStack(spacing: 10) {
                 ForEach(profile.getFollowers(), id: \.self) { user in
                     NavigationLink(destination: ProfileView(username: user)) {
                         genreLabel(text: user)
                     }
                    }
                }
                //.padding(.leading, 10)
            }).frame(height: 100)
            
            kHeader(text: "Following")
            ScrollView(.horizontal, content: {
                HStack(spacing: 10) {
                 ForEach(profile.getFollowing(), id: \.self) { user in
                     NavigationLink(destination: ProfileView(username: user)) {
                         genreLabel(text: user)
                     }
                    }
                }
                //.padding(.leading, 10)
            }).frame(height: 100)
        }
    }
}

struct FollowersDetailedView_Previews: PreviewProvider {
    
    static var previews: some View {
        FollowersDetailedView(profile: setupUser())
    }
    
    static func setupUser() -> User {
        let user: User = User()
        user.setUsername(username: "zachzach")
        return user
    }
}

//
//  FollowersDetailedView.swift
//  Shelf
//
//  Created by Zach Johnson on 10/28/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI

struct FollowersDetailedView: View {
    @State var username: String
    @ObservedObject var viewedProfile: User = User.otherUser
    
    var body: some View {
        VStack(alignment: .leading){
            
            kHeader(text: "Followers")
            ScrollView(.horizontal, content: {
                HStack(spacing: 10) {
                 ForEach(viewedProfile.getFollowers(), id: \.self) { user in
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
                 ForEach(viewedProfile.getFollowing(), id: \.self) { user in
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
        FollowersDetailedView(username: "zachzach")
    }
}

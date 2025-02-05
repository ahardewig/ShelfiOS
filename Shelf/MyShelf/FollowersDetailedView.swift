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
            
            if (profile.getFollowers().count > 0) {
                List(content: {
                    
                     ForEach(profile.getFollowers(), id: \.self) { user in
                         NavigationLink(destination: ProfileView(username: user)) {
                             profileSmall(text: user)
                         }
                        }
                    //.padding(.leading, 10)
                })
            } else {
                kSubtitle(text: "Whoops, looks like you don't have any followers")
            }
            
            
            Spacer()
            
            .navigationBarTitle("Followers")
            .navigationBarHidden(false)
        }.padding(16)
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

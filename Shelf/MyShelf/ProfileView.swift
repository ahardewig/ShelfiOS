//
//  ProfileView.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/13/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import URLImage

struct ProfileView: View {
    @State var username: String
    @State var gamesRated: [Game] = [];
    @State var followButtonText: String = "Follow"
    @ObservedObject var profile: User = User()
    var body: some View {
        VStack(alignment: .leading) {
        
            HStack(alignment: .top){
                Circle().padding().foregroundColor(Color(red: 0.98, green: 0.65, blue: 0.10, opacity: 1.0)).frame(width: 100, height: 100)
                VStack(alignment: .leading){

                    NavigationLink(destination: FollowersDetailedView(profile: profile)){
                        kBody(text: "\(profile.getFollowers().count) Followers")
                    }

                    NavigationLink(destination: FollowingDetailedView(profile: profile)){
                        kBody(text: "\(profile.getFollowing().count) Following")
                    }

                }.padding(.top, 24)

            }
            
            NavigationLink(destination: CertainGamesListView(profile: profile, gamesRated: $profile.games_rated)){
                kHeader(text: "Rated Games >")
            }
            
            RatedGamesHorizontalList(gamesRated: $profile.games_rated)
            
            
            Spacer()
            MessageButton(profile: profile)
            
            .navigationBarTitle(username)
                .navigationBarItems(trailing:  FollowButton(profile: profile, followButtonText: $followButtonText))
                
        }
        .onAppear {
            self.getUserData(username: self.username);
            
        }.frame(alignment: .top)
            .padding(.all, 16)
    }
    
    func setFollowStatus() {
        if(self.isFollowing(curProf: self.profile)) {
            self.followButtonText = "Unfollow"
        }
        else {
            self.followButtonText = "Follow"
        }
    }

    func isFollowing(curProf: User) -> Bool {
        print(User.currentUser.getFollowing())
        print(self.profile.getFollowers())
        return User.currentUser.getFollowing().contains(self.profile.getUsername())
    }
    
    func getUserData(username: String) {
        let headers: HTTPHeaders = [
                   "token": User.currentUser.getToken()
               ]
               let body: [String: String] = [
                "username": self.username,
               ]

        AF.request(DOMAIN + "user/data",
                           method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
                    if response.response?.statusCode == 200 {
                        self.profile.initFromJson(json: response.value as AnyObject)
                        print(self.profile.getGamesRated())
                        print(self.gamesRated)
                        self.gamesRated.append(contentsOf: self.profile.games_rated)
                        print(self.gamesRated)
                        self.setFollowStatus()
                        print(self.profile.games_rated[0].coverUrl)

                    } else {
                        let error = JSON(response.data as Any)
                        let errorMessage = error["message"].string
                        print(errorMessage as Any)
                    }

                }

    }
    
}

struct RatedGamesHorizontalList: View {
    @Binding var gamesRated: [Game];
    
    var body: some View {
  
        Group() {
        if (gamesRated.count > 0) {
            
            ScrollView(.horizontal, content: {
                HStack {
                    ForEach(gamesRated, id: \.gameId) { game in
                        URLImage(URL(string: game.coverUrl) ?? URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/co1pjc.jpg")!,
                                                processors: [ Resize(size: CGSize(width: 100.0, height: 150.0), scale: UIScreen.main.scale) ],
                                                content: {
                                                    $0.image
                                               .resizable()
                                               .aspectRatio(contentMode: .fill)
                                               .clipped()
                        }).frame(width: 180, height: 250)
                        }
                }
             }).frame(height: 250)
        }
        else {
            Text("Loading...")
        }
        }
    
    }
}


struct FollowingHorizontalList: View {
    @ObservedObject var profile: User
    
    var body: some View {
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

struct MessageButton: View {
    @ObservedObject var profile: User
    
    var body: some View {
        NavigationLink(destination: MessagingView(to: profile)) {
            Text("Message this user")
        }
    }
    
    func goToMessages() {
        print ("Going to messages");
    }
}

struct FollowersHorizontalList: View {
    @ObservedObject var profile: User
    
    var body: some View {
           List {
               ScrollView(.horizontal, content: {
                   HStack(spacing: 10) {
                    ForEach(profile.getFollowers(), id: \.self) { user in
                        NavigationLink(destination: ProfileView(username: user)) {
                            Text(user)
                        }
                       }
                   }
                   
               })
               .frame(height: 100)
           }.frame(height: 100)
         
    }
    
}

struct LogoutButton: View {
     @ObservedObject var profile: User
    var body: some View {
        Group() {
             if (User.currentUser.getUsername() == profile.getUsername()) {
                Button(action: {
                     User.currentUser.isLoggedIn = false;
                 }) {
                 Text("Logout")
                 }
             }
        }
    }
}


struct FollowButton: View {
    @ObservedObject var profile: User
    @Binding var followButtonText: String
    var body: some View {
        Group() {
             if (User.currentUser.getUsername() != profile.getUsername()) {
                    Button(action: {
                        if (self.followButtonText == "Follow") {
                            self.followUser()
                            self.followButtonText = "Unfollow"
                        }
                        else {
                            self.unfollowUser()
                            self.followButtonText = "Follow"
                        }
                    }) {
                        Text(followButtonText)
                    }
             } else {
                LogoutButton(profile: profile)
            }
        }
    }
    
    func followUser() {
        let headers: HTTPHeaders = [
            "token": User.currentUser.getToken()
        ]
        let body: [String: String] = [
            "user": profile.getUsername()
        ]
         AF.request(DOMAIN + "user/follow",
                    method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
             if response.response?.statusCode == 200 {

                self.profile.addFollower(follower: User.currentUser.getUsername())
                User.currentUser.addFollowing(following: self.profile.getUsername())

             } else {
                 let error = JSON(response.data as Any)
                 let errorMessage = error["message"].string
                 print(errorMessage as Any)
             }

         }
    }

    func unfollowUser() {
        let headers: HTTPHeaders = [
            "token": User.currentUser.getToken()
        ]
        let body: [String: String] = [
            "user": profile.getUsername()
        ]
         AF.request(DOMAIN + "user/unfollow",
                    method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
             if response.response?.statusCode == 200 {

                self.profile.removeFollower(follower: User.currentUser.getUsername())
                User.currentUser.removeFollowing(following: self.profile.getUsername())

             } else {
                 let error = JSON(response.data as Any)
                 let errorMessage = error["message"].string
                 print(errorMessage as Any)
             }

         }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(username: "alex123")
    }
}

struct ProfileHeader: View {
    @ObservedObject var profile: User
    @State var followButtonText: String
    var body: some View {
        HStack(alignment: .top){
            Circle().padding().foregroundColor(Color(red: 0.98, green: 0.65, blue: 0.10, opacity: 1.0)).frame(width: 100, height: 100)
            VStack(alignment: .leading){
                kHeader(text: profile.getUsername())
                NavigationLink(destination: FollowersDetailedView(profile: profile)){
                    kBody(text: "\(profile.getFollowers().count) Followers")
                    kBody(text: "\(profile.getFollowing().count) Followers")
                }
                
            }.padding(.top, 8)
            // Follow Button
            FollowButton(profile: profile, followButtonText: $followButtonText).padding(.top, 16).padding(.leading, 8)
        }
    }
}

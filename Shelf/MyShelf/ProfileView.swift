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
    @ObservedObject var viewedProfile: User = User.otherUser
    @State var gamesRated: [Game] = [];
    @State var followButtonText: String = "Follow"
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // Username Text
            ProfileHeader(username: $username)
            
            // Messaging View
//            if (username != User.currentUser.getUsername()) {
//                MessagingView(to: viewedProfile)
//            }

            // Follow Button
            FollowButton(viewedProfile: viewedProfile, followButtonText: $followButtonText)
            
            kHeader(text: "Rated Games:")
            RatedGamesHorizontalList(gamesRated: $gamesRated)
            
            LogoutButton()
            }
            
            
        .onAppear {
            self.gamesRated = [];
            self.getUserData(username: self.username);
            
        }.frame(alignment: .top)
        .padding(.all, 16)
    }
    
    func setFollowStatus() {
        if(self.isFollowing(curProf: self.viewedProfile)) {
            self.followButtonText = "Unfollow"
        }
        else {
            self.followButtonText = "Follow"
        }
    }
    
    func isFollowing(curProf: User) -> Bool {
        print(User.currentUser.getFollowing())
        print(self.viewedProfile.getFollowers())
        return User.currentUser.getFollowing().contains(self.viewedProfile.getUsername())
    }
    
    func getCovers() {
        for game in viewedProfile.getGamesRated() {
            setCoverId(id: game.gameId, game: game)
        }
    }
    
    func setCoverId(id: Int, game: Game) {
        let headers: HTTPHeaders = [
            "token": User.currentUser.getToken()
        ]
        let body: [String: Int] = [
            "id": id
        ]
         AF.request(DOMAIN + "games/detailedgamedata",
                    method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
             if response.response?.statusCode == 200 {
                let sampleJson = JSON(response.value as Any)
                let responseArray = sampleJson.array
                let parsed = responseArray?[0];
                let parsedCover = JSON(parsed?["cover"] as Any)
                let coverImageId = parsedCover["image_id"].string ?? ""
                var g: Game = Game(rating: game.rating, gameId: String(game.gameId))
                g.coverId = ("https://images.igdb.com/igdb/image/upload/t_cover_big/" + coverImageId + ".jpg")
                self.gamesRated.append(g)
                
             } else {
                 let error = JSON(response.data as Any)
                 let errorMessage = error["message"].string
                 print(errorMessage as Any)
             }
             
         }
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
                        User.otherUser.initFromJson(json: response.value as AnyObject)
                        self.getCovers();
                        self.setFollowStatus()
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
           ScrollView(.horizontal, content: {
               HStack(spacing: 10) {
                ForEach(gamesRated) { game in
                    
                    URLImage(URL(string: game.coverId )!,
                        processors: [ Resize(size: CGSize(width: 100.0, height: 150.0), scale: UIScreen.main.scale) ],
                        content: {
                            $0.image
                       .resizable()
                       .aspectRatio(contentMode: .fill)
                       .clipped()
                       }).frame(width: 100, height: 150)
                   }
               }
           })
           .frame(height: 150)

    }
}

struct FollowingHorizontalList: View {
    @ObservedObject var viewedProfile: User = User.otherUser
    
    var body: some View {
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

struct FollowersHorizontalList: View {
    @ObservedObject var viewedProfile: User = User.otherUser
    
    var body: some View {
           List {
               ScrollView(.horizontal, content: {
                   HStack(spacing: 10) {
                    ForEach(viewedProfile.getFollowers(), id: \.self) { user in
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
     @ObservedObject var viewedProfile: User = User.otherUser
    var body: some View {
        Group() {
             if (User.currentUser.getUsername() == viewedProfile.getUsername()) {
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
    @ObservedObject var viewedProfile: User = User.otherUser
    @Binding var followButtonText: String
    var body: some View {
        Group() {
             if (User.currentUser.getUsername() != viewedProfile.getUsername()) {
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
             }
        }
    }
    
    func followUser() {
        let headers: HTTPHeaders = [
            "token": User.currentUser.getToken()
        ]
        let body: [String: String] = [
            "user": viewedProfile.getUsername()
        ]
         AF.request(DOMAIN + "user/follow",
                    method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
             if response.response?.statusCode == 200 {
                
                self.viewedProfile.addFollower(follower: User.currentUser.getUsername())
                User.currentUser.addFollowing(following: self.viewedProfile.getUsername())
                
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
            "user": viewedProfile.getUsername()
        ]
         AF.request(DOMAIN + "user/unfollow",
                    method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
             if response.response?.statusCode == 200 {
                
                self.viewedProfile.removeFollower(follower: User.currentUser.getUsername())
                User.currentUser.removeFollowing(following: self.viewedProfile.getUsername())
                
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
    @Binding var username: String
    @ObservedObject var viewedProfile: User = User.otherUser
    var body: some View {
        HStack{
            Circle().padding().foregroundColor(Color(red: 0.98, green: 0.65, blue: 0.10, opacity: 1.0)).frame(width: 100, height: 100)
            VStack(alignment: .leading){
                kHeader(text: username)
                NavigationLink(destination: FollowersDetailedView(username: username)){
                    kBody(text: "\(viewedProfile.getFollowers().count) Followers")
                    kBody(text: "\(viewedProfile.getFollowing().count) Followers")
                }
                
            }
            
        }
        
    }
}

//NavigationLink(destination: DetailedGameView(gameOverview: game, detailedGame: DetailedGame())) {
//    URLImage(URL(string: self.url + game.coverImageId + ".jpg")!,
//             processors: [ Resize(size: CGSize(width: 100.0, height: 150.0), scale: UIScreen.main.scale) ],
//        content: {
//            $0.image
//    .resizable()
//    .aspectRatio(contentMode: .fill)
//    .clipped()
//    }).frame(width: 100, height: 150)
//
//    VStack(alignment: .leading) {
//        kSubtitle(text: "Game Title")
//        StarRatingView(games: self.$games, gameId: game.id, canEdit: false)
//    }
//}

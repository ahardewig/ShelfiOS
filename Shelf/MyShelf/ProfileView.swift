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
    var body: some View {
        VStack {
            Text(viewedProfile.getUsername())
            Text("Followers:")
            Text("Following:")
            Text("Rated Games:")
            
               List {
                   
                   // statuses
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
                       .padding(.leading, 10)
                   })
                   .frame(height: 190)
                   
               }
               .padding(.leading, -20)
               .padding(.trailing, -20)
               .navigationBarTitle(Text("Home"))
                   
            
            
        }.onAppear {
            self.gamesRated = [];
            self.getUserData(username: self.username);
        }
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
         AF.request("http://localhost:8080/games/detailedgamedata",
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
        
        AF.request("http://localhost:8080/user/data",
                           method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
                    if response.response?.statusCode == 200 {
                        User.otherUser.initFromJson(json: response.value as AnyObject)
                        self.getCovers();
                    } else {
                        let error = JSON(response.data as Any)
                        let errorMessage = error["message"].string
                        print(errorMessage as Any)
                    }
                    
                }
        
    }
}


//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(user: {})
//    }
//}

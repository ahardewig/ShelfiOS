//
//  DetailedGameView.swift
//  Shelf
//
//  Created by Ben Kahlert on 10/24/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI
import URLImage
import Alamofire
import SwiftyJSON

struct DetailedGameView: View {
    @State var gameOverview: GameOverview;
    @State var detailedGame: DetailedGame;
    @State var userRating: Int = 0;
    
    let coverUrl = "https://images.igdb.com/igdb/image/upload/t_cover_big/"
    let artworkUrl = "https://images.igdb.com/igdb/image/upload/t_screenshot_big/"
    
    var body: some View {
        ScrollView {
            VStack {
                
                // FOR ZACH: I THINK THE PACKAGE OWNER FOR URLIMAGE said that you can do anything to it that you can for a normal image
                 Text("NAME: \(gameOverview.name)")
                URLImage(URL(string: self.coverUrl + gameOverview.coverImageId + ".jpg")!)
                
                UserRatingView(userRating: self.$userRating, canEdit: true, gameId: self.$gameOverview.id)
               
                Text("STORYLINE: \(detailedGame.storyline)")
                Text("GENRES")
                ForEach(detailedGame.genres, id: \.self) { genre in
                    Text("\(genre)")
                }
                Text("PLATFORMS")
                ForEach(detailedGame.platforms, id: \.self) { platform in
                    Text("\(platform)")
                }
                Text("ARTWORKS")
                ForEach(detailedGame.artworkImageIds, id: \.self) { imageId in
                    URLImage(URL(string: self.artworkUrl + imageId + ".jpg")!)
                }
            }
        }.onAppear {
            self.getGameById(gameId: self.gameOverview.id)
            self.getUserRating(gameId: self.gameOverview.id)
            
        }
            
    }
    
    func getUserRating(gameId: Int) {
    
        let headers: HTTPHeaders = [
            "token": User.currentUser.getToken()
        ]
        AF.request(DOMAIN + "user/\(User.currentUser.getUsername())/games-rated/\(gameId)", headers: headers).responseJSON { response in
             if response.response?.statusCode == 200 {
                let json = JSON(response.value as Any);
                let rate: Int = json["rating"].int ?? 0
                self.userRating = rate
                print(response.value as Any)
             } else {
                 let error = JSON(response.data as Any)
                 let errorMessage = error["message"].string
                 print(errorMessage as Any)
             }
             
         }
     }
    
    func getGameById(gameId: Int) {
    
        let headers: HTTPHeaders = [
            "token": User.currentUser.getToken()
        ]
        let body: [String: String] = [
            "id": String(gameOverview.id)
        ]
         AF.request(DOMAIN + "games/detailedgamedata",
                    method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
             if response.response?.statusCode == 200 {
                 self.getDetailedGameInfo(response: response.value as Any);
             } else {
                 let error = JSON(response.data as Any)
                 let errorMessage = error["message"].string
                 print(errorMessage as Any)
             }
             
         }
     }
    
    func getDetailedGameInfo(response: Any) {
        print ("Getting the detailed info")
        detailedGame = DetailedGame(game: response)
    }
}

struct DetailedGameView_Previews: PreviewProvider {
    
    static var previews: some View {
        DetailedGameView(gameOverview: GameOverview(game: "" as Any), detailedGame: DetailedGame(game: "" as Any), userRating: 3)
    }
}

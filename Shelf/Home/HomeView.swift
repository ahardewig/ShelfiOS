//
//  HomeView.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/10/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI
import URLImage
import Alamofire
import SwiftyJSON

struct HomeView: View {
    
    @State var games: [GameOverview] = []
    let url = "https://images.igdb.com/igdb/image/upload/t_cover_big/"
    
    var body: some View {
        NavigationView {
            List(games, id: \.id) { game in
                NavigationLink(destination: DetailedGameView(gameOverview: game, detailedGame: DetailedGame())) {
                    URLImage(URL(string: self.url + game.coverImageId + ".jpg")!,
                             processors: [ Resize(size: CGSize(width: 100.0, height: 150.0), scale: UIScreen.main.scale) ],
                        content: {
                            $0.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    }).frame(width: 100, height: 150)
                    
                    VStack {
                        StarRatingView(games: self.$games, gameId: game.id, canEdit: false)
                        StarRatingView(games: self.$games, gameId: game.id, canEdit: true)
                    }
                }
                
            }
        }.onAppear {
            self.getGames()
        }
    }
    
    func getGames() {
   
        let headers: HTTPHeaders = [
            "token": User.currentUser.getToken()
        ]
        AF.request("http://localhost:8080/games/criticallyacclaimedgames",
                   headers: headers).responseJSON { response in
            if response.response?.statusCode == 200 {
                self.getGameOverviewsArray(response: response.value as Any);
                self.getGlobalRatings();
                self.getUserRatings();
            } else {
                let error = JSON(response.data as Any)
                let errorMessage = error["message"].string
                print(errorMessage as Any)
            }
            
        }
    }
    
    func getGlobalRatings() {
        
        let headers: HTTPHeaders = [
            "token": User.currentUser.getToken()
        ]
        AF.request("http://localhost:8080/ratingInfo/all",
                   headers: headers).responseJSON { response in
            if response.response?.statusCode == 200 {
                
                let sampleJson = JSON(response.value as Any)
                let responseArray = sampleJson.array
                var ratings: [RatingInfo] = [];
                for ratingInfo in responseArray! {
                    let r: RatingInfo = RatingInfo();
                    r.initFromJson(json: ratingInfo)
                    ratings.append(r)
                }
                self.attachGlobalRatingsToGames(ratingInfos: ratings)
            } else {
                let error = JSON(response.data as Any)
                let errorMessage = error["message"].string
                print(errorMessage as Any)
            }
            
        }
    }
    
    func getUserRatings() {
        self.attachUserRatingsToGames(gamesRated: User.currentUser.getGamesRated())
    }
    
    func attachUserRatingsToGames(gamesRated : [Game]) {
        var map: [Int: Int] = [:]
       
        for game in gamesRated {
            map.updateValue(game.rating, forKey: game.gameId)
        }
        
        var updatedGames: Array<GameOverview> = []
        for game in games {
            let key = game.id;
            let keyExists = map[key] != nil
            if (keyExists) {
                let score: Int = map[key] ?? 0;
                print("SCORE \(score)");
                game.userRating = score
                updatedGames.append(game);
            }
            else {
                print("DOING ZERO")
                game.userRating = 0;
                updatedGames.append(game)
                
            }
        }
        games = updatedGames;

    }
    

    
    func attachGlobalRatingsToGames(ratingInfos : [RatingInfo]) {
        var map: [Int: Int] = [:]
       
        for ratingInfo in ratingInfos {
            var score: Int = 0;
            if (ratingInfo.numberOfRatings != 0) {
                score = ratingInfo.totalRatingValue / ratingInfo.numberOfRatings;
            }
            map.updateValue(score, forKey: Int(ratingInfo.gameId) ?? 0)
        }
        
        var updatedGames: Array<GameOverview> = []
        for game in games {
            let key = game.id;
            let keyExists = map[key] != nil
            if (keyExists) {
                let score: Int = map[key] ?? 0;
                game.globalRating = score
                updatedGames.append(game);
            }
            else {
                game.globalRating = 0;
                updatedGames.append(game)
                
            }
        }
        games = updatedGames;

    }
    
    func getGameOverviewsArray(response: Any) {
        let sampleJson = JSON(response)
        let responseArray = sampleJson.array
        
        for game in responseArray! {
            let newGame = GameOverview(game: game)
            games.append(newGame)
        }
    }
    
}

struct RandomText: View {
    var body: some View {
        Text("This is random text!")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

struct RandomButton: View {
    var body: some View {
        Text("GET THE GAMES")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 320, height: 60)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

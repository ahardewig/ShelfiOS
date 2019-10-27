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
    @State var showSortingSheet: Bool = false
    @State var currentSortingMethod: SortingEnum = SortingEnum.GlobalDescending
    let url = "https://images.igdb.com/igdb/image/upload/t_cover_big/"

    
    var body: some View {
        
            
            HStack {
                    
                    List(games.sorted(by: customSorter), id: \.id) { game in
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
                            }
                        }
                    }.navigationBarTitle(Text("Global Games").font(KarlaHeader))
                }.onAppear {
                    self.getGames()
                    //self.refreshUser()


            }.font(KarlaSubtitle).frame(height: 675).navigationBarItems(trailing: SortingSheetView(showSortingSheet: $showSortingSheet, currentSortingMethod: $currentSortingMethod))

                
        

        

    }
    
    func refreshUser() {
            let headers: HTTPHeaders = [
                       "token": User.currentUser.getToken()
                   ]
                   let body: [String: String] = [
                    "username": User.currentUser.getUsername(),
                   ]
            
            AF.request(DOMAIN + "user/data",
                               method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
                        if response.response?.statusCode == 200 {
                            User.currentUser.initFromJson(json: response.value as AnyObject)
                            self.getUserRatings()
                        } else {
                            let error = JSON(response.data as Any)
                            let errorMessage = error["message"].string
                            print(errorMessage as Any)
                        }
                        
                    }
    }
    
    func customSorter(this:GameOverview, that:GameOverview) -> Bool {

        switch currentSortingMethod {
            
            case .GlobalAscending:
                return this.globalRating < that.globalRating
            case .UserAscending:
            
                return this.userRating < that.userRating
            case .UserDescending:
                return this.userRating > that.userRating
            default:
                return this.globalRating > that.globalRating
        }
      
    }
    
    func getGames() {
   
        let headers: HTTPHeaders = [
            "token": User.currentUser.getToken()
        ]
        AF.request(DOMAIN + "games/criticallyacclaimedgames",
                   headers: headers).responseJSON { response in
            if response.response?.statusCode == 200 {
                self.getGameOverviewsArray(response: response.value as Any)
                self.getGlobalRatings()
                self.refreshUser()
             
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
        AF.request(DOMAIN + "ratingInfo/all",
                   headers: headers).responseJSON { response in
            if response.response?.statusCode == 200 {
                
                let sampleJson = JSON(response.value as Any)
                let responseArray = sampleJson.array
                var ratings: [RatingInfo] = []
                for ratingInfo in responseArray! {
                    let r: RatingInfo = RatingInfo()
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
        for game in self.games {
            let key = game.id
            let keyExists = map[key] != nil
            if (keyExists) {
                let score: Int = map[key] ?? 0
                print("SCORE \(score)")
                game.userRating = score
                updatedGames.append(game)
            }
            else {
                print("DOING ZERO")
                game.userRating = 0
                updatedGames.append(game)
                
            }
        }
        self.games = updatedGames

    }
    

    
    func attachGlobalRatingsToGames(ratingInfos : [RatingInfo]) {
        var map: [Int: Int] = [:]
       
        for ratingInfo in ratingInfos {
            var score: Int = 0
            if (ratingInfo.numberOfRatings != 0) {
                score = ratingInfo.totalRatingValue / ratingInfo.numberOfRatings
            }
            map.updateValue(score, forKey: Int(ratingInfo.gameId) ?? 0)
        }
        
        var updatedGames: Array<GameOverview> = []
        for game in games {
            let key = game.id
            let keyExists = map[key] != nil
            if (keyExists) {
                let score: Int = map[key] ?? 0
                game.globalRating = score
                updatedGames.append(game)
            }
            else {
                game.globalRating = 0
                updatedGames.append(game)
                
            }
        }
        games = updatedGames

    }
    
    func getGameOverviewsArray(response: Any) {
        let sampleJson = JSON(response)
        let responseArray = sampleJson.array
        games = [];
        for game in responseArray! {
            let newGame = GameOverview(game: game)
            games.append(newGame)
        }
    }
    
    
}

enum SortingEnum {
    case GlobalAscending
    case GlobalDescending
    case UserAscending
    case UserDescending
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

struct SortingSheetView: View {
    @Binding var showSortingSheet: Bool
    @Binding var currentSortingMethod: SortingEnum
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Sorting"), message: Text("Choose Option"), buttons: [
            .default(Text("Global Descending"), action: {
                self.showSortingSheet.toggle()
                self.currentSortingMethod = SortingEnum.GlobalDescending
                
            }),
            .default(Text("Global Ascending"), action: {
                self.showSortingSheet.toggle()
                self.currentSortingMethod = SortingEnum.GlobalAscending
            }),
            .default(Text("User Descending"), action: {
                self.showSortingSheet.toggle()
                self.currentSortingMethod = SortingEnum.UserDescending
            }),
            .default(Text("User Ascending"), action: {
                self.showSortingSheet.toggle()
                self.currentSortingMethod = SortingEnum.UserAscending
            }),
            
        ])
    }
    
    
    var body: some View {
        
        Button(action: {
            self.showSortingSheet.toggle()
        }) {
            Image(systemName:"arrow.up.arrow.down.circle.fill")
                .imageScale(.large)
                .frame(width:24, height: 24).foregroundColor(.black)
        }
        .actionSheet(isPresented: $showSortingSheet, content: {
            self.actionSheet })
    }
}

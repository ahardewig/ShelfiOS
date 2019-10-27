//
//  SearchView.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/13/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI
import URLImage
import Alamofire
import SwiftyJSON

struct SearchView: View {
    
    @State var games: Array<GameOverview> = []
    @State var query: String = ""
    @State var test: Bool = false;
    
    let url = "https://images.igdb.com/igdb/image/upload/t_cover_big/"
    
    var body: some View {
        VStack{
            QueryTextField(query: $query).padding(.leading, 16).padding(.trailing, 16)
            Button(action: {self.searchGames(query: self.query)}) {
                primaryCTAButton(text: "Search")
            }
            Group {
                List(games, id: \.id) { game in
                    NavigationLink(destination: DetailedGameView(gameOverview: game, detailedGame: DetailedGame())) {
                        
                        HStack(alignment: .top){
                            
                            URLImage(URL(string: self.url + game.coverImageId + ".jpg")!,
                                     processors: [ Resize(size: CGSize(width: 100.0, height: 150.0), scale: UIScreen.main.scale) ],
                                content: {
                                    $0.image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            }).frame(width: 100, height: 150)
                            
                            VStack(alignment: .leading){
                                kSubtitle(text: game.name)
                                StarRatingView(games: self.$games, gameId: game.id, canEdit: false)
                            }
                            
                        }
                        
                    }
                }
            }.onAppear {self.getGames()}
                .navigationBarTitle("Search")
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
            } else {
                let error = JSON(response.data as Any)
                let errorMessage = error["message"].string
                print(errorMessage as Any)
            }
        }
    }
    
    func searchGames(query: String) {
        
        let body: [String: String] = [
            "search": query,
        ]
        let headers: HTTPHeaders = [
            "token": User.currentUser.getToken()
        ]
        
        AF.request("http://localhost:8080/games/searchedgames", method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
            if response.response?.statusCode == 200 {
                self.games = [];
                self.getGameOverviewsArray(response: response.value as Any);
            } else {
                let error = JSON(response.data as Any)
                let errorMessage = error["message"].string
                print(errorMessage as Any)
            }
        }
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

struct QueryTextField: View {
    @Binding var query: String
    
    var body: some View {
        TextField("Search" , text: $query )
        .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .font(KarlaInput)
            .keyboardType(.webSearch)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

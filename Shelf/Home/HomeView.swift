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
    
    @State var games: Array<GameOverview> = []
    let urls = (300..<305).map { "https://picsum.photos/\($0)" }.map { URL(string: $0)! }
    
    var body: some View {
        
        NavigationView {
            List(games, id: \.id) { game in
                NavigationLink(destination: DetailedGameView(name: game.name)) {
                    URLImage(URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/" + game.coverImageId + ".jpg")!,
                        content: {
                            $0.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    }).frame(width: 100, height: 150)
                }
            }
        }.onAppear {self.getGames()}
        .navigationBarTitle("Critically Acclaimed")
        
        
        //List {
//            VStack {
//                List(games, id: \.id) { game in
//                    NavigationLink(destination: DetailedGameView()) {
//                        URLImage(URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/" + game.coverImageId + ".jpg")!)
//                    }
//                }
//            }.onAppear { self.getGames() }
        //}.onAppear { self.getGames() }
        
        
//        List {
//            VStack {
//                List(games, id: \.id) { game in
//                    NavigationLink(destination: DetailedGameView()) {
//                        URLImage(URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/" + game.coverImageId + ".jpg")!)
//                    }
//                }
//            }
//        }.onAppear { self.getGames() }
        
//        NavigationView {
//            List(games, id: \.id) { message in
//                NavigationLink(destination: DetailedGameView()) {
//                    URLImage(URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/" + game.coverImageId + ".jpg")!)
//                }
//            }.navigationBarTitle("Messages")
//        }.onAppear {self.getGames()}
    }
    
    func getGames() {
    AF.request("http://localhost:8080/games/criticallyacclaimedgames").responseJSON { response in
            if response.response?.statusCode == 200 {
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

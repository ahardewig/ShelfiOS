//
//  FollowersDetailedView.swift
//  Shelf
//
//  Created by Zach Johnson on 10/28/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI
import URLImage
import Alamofire
import SwiftyJSON

struct CertainGamesListView: View {
    @ObservedObject var profile: User
    @Binding var gamesRated: [Game];
    @State var showSortingSheet: Bool = false
    @State var currentSortingMethod: SortingEnum = SortingEnum.UserDescending
    //@State var isLoading: Bool = true;
    
    var body: some View {
        //VStack {
            HStack {
                List(self.gamesRated.sorted(by: self.customSorter), id: \.id) { game in

                    Group() {
                          URLImage(URL(string: game.coverUrl )!,
                              processors: [ Resize(size: CGSize(width: 100.0, height: 150.0), scale: UIScreen.main.scale) ],
                              content: {
                                  $0.image
                             .resizable()
                             .aspectRatio(contentMode: .fill)
                             .clipped()
                             }).frame(width: CGFloat(100), height: CGFloat(150))
                         
                        VStack(alignment: .leading) {
                            //kSubtitle(text: game.name)
                            Text("Global Rating")
                            StarRatingNoVote(userRating: game.globalRating)
                            Text("User Rating")
                            StarRatingNoVote(userRating: game.userRating)
                        }
                      
                      }
                }

            }.navigationBarItems(trailing: SortingSheetView(showSortingSheet: $showSortingSheet, currentSortingMethod: $currentSortingMethod))
                .onAppear() {
                    self.getMultipleGameOverviews(gamesRated: self.gamesRated);
        }
    }
    
    
    func getMultipleGameOverviews(gamesRated: [Game]) {
        let headers: HTTPHeaders = [
                   "token": User.currentUser.getToken()
               ]
        
        var gameIds: [String] = [];
        for game in gamesRated {
            gameIds.append(String(game.gameId))
        }
        let body: [String: [String]] = [
            "gameIds": gameIds,
        ]

        AF.request(DOMAIN + "games/multiplegameoverviews/\(User.currentUser.getUsername())",
                           method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
                    if response.response?.statusCode == 200 {
//                        self.profile.initFromJson(json: response.value as AnyObject)
                        print(JSON(response.data as Any))
                        let obj = JSON(response.data as Any)
                        var gameArr: [Game] = []
                        for game in obj.array! {
                            gameArr.append(Game.init(json: game))
                        }
                        
                        self.gamesRated = gameArr

                    } else {
                        let error = JSON(response.data as Any)
                        let errorMessage = error["message"].string
                        print(errorMessage as Any)
                    }

                }

    }
    
    
    func customSorter(this:Game, that:Game) -> Bool {

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
}

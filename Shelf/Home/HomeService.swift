//
//  HomeService.swift
//  Shelf
//
//  Created by Ben Kahlert on 10/21/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//func getGames() {
//    AF.request("http://localhost:8080/games/criticallyacclaimedgames").responseJSON { response in
//        if response.response?.statusCode == 200 {
//            getGameOverviewsArray(response: response.value as Any);
//        } else {
//            let error = JSON(response.data as Any)
//            let errorMessage = error["message"].string
//            print(errorMessage as Any)
//        }
//        
//    }
//}
//
//func getGameOverviewsArray(response: Any) {
//    
//    let sampleJson = JSON(response)
//    let responseArray = sampleJson.array
//    for game in responseArray! {
//        print ("In the loop!")
//        let newGame = GameOverview(game: game)
//        newGame.toString()
//        games.append(newGame)
//    }
//}

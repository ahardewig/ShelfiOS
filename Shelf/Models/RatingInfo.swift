//
//  RatingInfo.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/25/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import Foundation
import SwiftyJSON

class RatingInfo {
    
    public var totalRatingValue: Int = 0;
    public var numberOfPlayers: Int = 0;
    public var numberOfRatings: Int = 0;
    public var gameId: String = "";
    
    
    init(){
        
    }
    
    init(totalRatingValue: Int, numberOfPlayers: Int,
         numberOfRatings: Int, gameId: String) {
        self.totalRatingValue = totalRatingValue;
        self.numberOfPlayers = numberOfPlayers;
        self.numberOfRatings = numberOfRatings;
        self.gameId = gameId;
    }
    
    func initFromJson(json: Any) {
        
        let parsed = JSON(json);
        print(parsed);
        
        self.totalRatingValue = parsed["total_rating_value"].int ?? 0;
        self.numberOfPlayers = parsed["number_of_players"].int ?? 0;
        self.numberOfRatings = parsed["number_of_ratings"].int ?? 0;
        self.gameId = parsed["game_id"].string ?? "";
        
        
    }

}

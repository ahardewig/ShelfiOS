//
//  Game.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/13/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

class Game: Identifiable {
    
    
    public var rating: Int = 0;
    public var gameId: Int = 0;
    public var coverId: String = "https://images.igdb.com/igdb/image/upload/t_cover_big/co1nt4.jpg";
    public var coverUrl: String = ""
    public var name: String = ""
    public var globalRating: Int = 0
    public var userRating: Int = 0
    
    
    
    init(rating: Int, gameId: String) {
        self.rating = rating;
        self.gameId = Int(gameId) ?? -999;
    }
    
    init(rating: Int, gameId: String, coverUrl: String) {
        self.rating = rating;
        self.gameId = Int(gameId) ?? -999;
        self.coverUrl = coverUrl;
    }
    
    init(json: Any) {
        let parsed = JSON(json)
        self.gameId = parsed["id"].int ?? 0
        self.name = parsed["name"].string ?? "Loading"
        self.globalRating = parsed["globalRating"].int ?? 0
        self.userRating = parsed["userRating"].int ?? 0
        let parsedCover = JSON(parsed["cover"])
        let cover = parsedCover["image_id"].string ?? ""
        self.coverUrl = "https://images.igdb.com/igdb/image/upload/t_cover_big/" + cover + ".jpg"
    }
    
}

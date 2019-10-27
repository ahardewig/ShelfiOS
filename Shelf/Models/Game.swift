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
    
    public var rating: Int;
    public var gameId: Int;
    public var coverId: String = "https://images.igdb.com/igdb/image/upload/t_cover_big/co1nt4.jpg";
    
    
    init(rating: Int, gameId: String) {
        self.rating = rating;
        self.gameId = Int(gameId) ?? -999;
       
    }
}

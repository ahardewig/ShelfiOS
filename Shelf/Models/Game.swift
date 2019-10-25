//
//  Game.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/13/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import Foundation

import Foundation
import SwiftyJSON

class Game {
    
    public var rating: Int;
    public var gameId: Int;
    
    
    init(rating: Int, gameId: String) {
        self.rating = rating;
        self.gameId = Int(gameId) ?? -999;
    }
}

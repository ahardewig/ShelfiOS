//
//  Game.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/13/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import Foundation
import SwiftyJSON

class Game {
    
    private var rating: String;
    private var gameId: String;
    
    
    init(rating: String, gameId: String) {
        self.rating = rating;
        self.gameId = gameId;
    }
}

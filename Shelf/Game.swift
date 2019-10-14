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
    
    private var rating: Int;
    private var gameId: Int;
    
    
    init(rating: Int, gameId: Int) {
        self.rating = rating;
        self.gameId = gameId;
    }
}

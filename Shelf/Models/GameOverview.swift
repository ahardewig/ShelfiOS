//
//  Game.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/13/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import Foundation
import SwiftyJSON

class GameOverview {
    public var id: Int = 0
    public var name: String = ""
    public var coverId: Int = 0
    public var coverImageId: String = ""
    
    public init() {
        
    }
    
    public init(game: Any) {
        initFromJson(json: game)
    }
    
    func initFromJson(json: Any) {
        let parsedJson = JSON(json)
        self.id = parsedJson["id"].int ?? 0
        self.name = parsedJson["name"].string ?? ""
        let parsedCover = JSON(parsedJson["cover"])
        self.coverImageId = parsedCover["image_id"].string ?? ""
        self.coverId = parsedCover["id"].int ?? 0
    }
    
    func toString() {
        print("NAME: " + self.name)
        print("COVER_IMAGE_ID: " + self.coverImageId)
    }
}

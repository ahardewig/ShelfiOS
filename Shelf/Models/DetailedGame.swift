//
//  Game.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/13/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import Foundation
import SwiftyJSON

class DetailedGame {
    public var storyline: String = ""
    public var platforms: Array<String> = []
    public var genres: Array<String> = []
    public var artworkImageIds: Array<String> = []
    
    public init() {
        
    }
    
    public init(game: Any) {
        let tempParsed = JSON(game)
        let parsedJson = JSON(tempParsed)
        let jsonArray = parsedJson.array ?? [];
        
        if jsonArray.count == 0 {
            return
        }
        initFromJson(json: game)
    }
    
    func initFromJson(json: Any) {
    
        
        let parsedJson = JSON(json)
        let jsonArray = parsedJson.array ?? [];
        let game = jsonArray[0]
        let parsedGame = JSON(game)
        
        print (parsedGame)
        
        self.storyline = parsedGame["storyline"].string ?? ""
        let artworksArray = parsedGame["artworks"].array ?? []
        for artwork in artworksArray {
            artworkImageIds.append(artwork["image_id"].string!)
        }
        let genresArray = parsedGame["genres"].array ?? []
        for genre in genresArray {
            genres.append(genre["name"].string ?? "")
        }
        let platformsArray = parsedGame["platforms"].array ?? []
        for platform in platformsArray {
            platforms.append(platform["name"].string ?? "")
        }
        
        toString()
    }
    
    func toString() {
        print ("storyline: " + self.storyline)
        for artwork in self.artworkImageIds {
            print ("ARTWORK: " + artwork)
        }
        for genre in self.genres {
            print ("GENRE: " + genre)
        }
        for platform in self.platforms {
            print ("PLATFORM: " + platform)
        }
    }
}

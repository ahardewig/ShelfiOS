//
//  UserOverview.swift
//  Shelf
//
//  Created by Ben Kahlert on 10/26/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserOverview {
    public var id: Int = 0
    public var username: String = ""
    
    public init() {
        
    }
    
    public init(user: Any) {
        initFromJson(json: user)
    }
    
    func initFromJson(json: Any) {
        let parsedJson = JSON(json)
        self.id = parsedJson["_id"].int ?? 0
        self.username = parsedJson["username"].string ?? ""
    }
    
    func toString() {
        print("NAME: " + self.username)
    }
}

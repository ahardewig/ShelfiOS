//
//  Message.swift
//  Shelf
//
//  Created by Ben Kahlert on 10/26/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import Foundation
import SwiftyJSON

class Message {
    public var sender: String = ""
    public var message: String = ""
    public var id: Int = 0
    
    public init() {
        
    }
    
    public init(message: Any) {
        initFromJson(json: message)
    }
    
    func initFromJson(json: Any) {
        let parsedJson = JSON(json)
        self.sender = parsedJson["sender"].string ?? ""
        self.message = parsedJson["message"].string ?? ""
        // TODO: I think this is actually _id, need to test with messaging that works
        self.id = parsedJson["id"].int ?? 0
    }
}

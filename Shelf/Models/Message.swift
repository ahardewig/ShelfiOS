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
    public var id: String = ""
    
    public init() {
        
    }
    
    public init(message: Any) {
        initFromJson(json: message)
    }
    
    func initFromJson(json: Any) {
        let parsedJson = JSON(json)
        self.sender = parsedJson["sender"].string ?? ""
        self.message = parsedJson["message"].string ?? ""
        self.id = parsedJson["_id"].string ?? ""
//        print ("ID: " + String(self.id))
    }
}

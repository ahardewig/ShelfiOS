//
//  Notification.swift
//  Shelf
//
//  Created by Connor Toddd on 12/4/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

class Notification: Identifiable {
    
    public var sender: String = "";
    public var message: String = "";
    public var timeStamp: String = "";
    public var hasBeenRead: Bool = false;
    public var type: String = "";
    
    init(json: Any, type: String) {
        let parsed = JSON(json);
//        print(parsed)
        self.sender = parsed["sender"].string ?? "";
        self.message = parsed["message"].string ?? "";
        self.timeStamp = parsed["time_stamp"].string ?? "";
        self.hasBeenRead = parsed["hasBeenRead"].bool ?? false;
        self.type = type;
    }
}

//
//  BackendConstants.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/26/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import Foundation

let DOMAIN = "http://localhost:8080/"

func SEND_MESSAGE_NOTIFICATION(sender: String, receiver: String) -> String {
    return ( "Hello " + receiver + ", you have a new message from " + sender);
}

func NEW_FOLLOWER_NOTIFICATION(sender: String, receiver: String) -> String {
    return ( "Hello " + receiver + ", " + sender + " has begun following you!");
}

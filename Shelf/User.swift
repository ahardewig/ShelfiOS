//
//  User.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/13/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {
    
    private var username: String = "";
    private var birthday: String = "";
    private var email: String = "";
    private var games_rated:  Array<Game> = [];
    
    static let currentUser = User();
    
    private init() {
        //SINGLETON
    }
    
    
    func setUsername(username: String) {
        self.username = username;
    }
    
    func getUsername() -> String {
        return self.username;
    }
    
    func setBirthday(birthday: String) {
        self.birthday = birthday;
    }
    
    func getBirthday() -> String {
        return self.birthday;
    }
    
    func setEmail(email: String) {
        self.email = email;
    }
    
    func getEmail() -> String {
        return self.email;
    }
    
    func initFromJson(json: Any) {
        let parsed = JSON(json);
        self.username = parsed["username"].string ?? "";
        for games in parsed["games_rated"].array! {
            print(games["rating"]);
            //self.games_rated.append(Game(games.rating, games.game_id))
        }
        //self.games_rated.append(Game())
        
    }

}

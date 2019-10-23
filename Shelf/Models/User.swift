//
//  User.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/13/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: ObservableObject {
    
    private var username: String = "";
    private var birthday: String = "";
    private var email: String = "";
    private var games_rated:  Array<Game> = [];
    private var games_played: Array<Game> = [];
    private var followers: [String] = [];
    private var following: [String] = [];
    private var inboxId: String = "";
    private var token: String = "";
    
    @Published var isLoggedIn: Bool = false;
    
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
    
    func setToken(token: String) {
        self.token = token;
    }
    
    func getToken() -> String {
        return self.token;
    }
    
    
    func initFromJson(json: Any) {
        self.isLoggedIn = true;
        let parsed = JSON(json);
        print(parsed);
        
        self.username = parsed["username"].string ?? "";
        self.birthday = parsed["birthday"].string ?? "";
        self.email = parsed["email"].string ?? "";
        self.inboxId = parsed["inboxID"].string ?? "";
        
        for games in parsed["games_rated"].array! {
            print(games["rating"]);
            let rating = games["rating"].string ?? ""
            let gameId = games["game_id"].string ?? ""
            self.games_rated.append(Game(rating: rating, gameId: gameId))
        }
        
        for games in parsed["games_played"].array! {
            print(games["rating"]);
            let rating = games["rating"].string ?? ""
            let gameId = games["game_id"].string ?? ""
            self.games_played.append(Game(rating: rating, gameId: gameId))
        }
        
        for follower in parsed["followers"].array! {
            self.followers.append(follower.string!)
        }
        
        for following in parsed["following"].array! {
            self.following.append(following.string!)
        }
    }

}

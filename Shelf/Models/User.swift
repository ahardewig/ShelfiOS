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
    
    @Published private var username: String = "";
    @Published private var birthday: String = "";
    @Published private var email: String = "";
    @Published private var games_rated:  Array<Game> = [];
    @Published private var games_played: Array<Game> = [];
    @Published private var followers: [String] = [];
    @Published private var following: [String] = [];
    @Published private var inboxId: String = "";
    @Published private var token: String = "";
    
    @Published var isLoggedIn: Bool = false;
    
    static let currentUser = User();
    static let otherUser = User();
    
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
    
    func getGamesRated() -> Array<Game> {
        return self.games_rated;
    }
    
    func initFromJson(json: Any) {
        self.games_rated = [];
        self.games_played = [];
        self.followers = [];
        self.following = []
        
        self.isLoggedIn = true;
        let parsed = JSON(json);
        print(parsed);
        
        self.username = parsed["username"].string ?? "";
        self.birthday = parsed["birthday"].string ?? "";
        self.email = parsed["email"].string ?? "";
        self.inboxId = parsed["inboxID"].string ?? "";
        
        for games in parsed["games_rated"].array! {
            print(games["rating"]);
            let rating = games["rating"].int ?? 0
            let gameId = games["game_id"].string ?? "-999"
            self.games_rated.append(Game(rating: rating, gameId: gameId ))
        }
        
        for games in parsed["games_played"].array! {
            print(games["rating"]);
            let rating = games["rating"].int ?? 0
            let gameId = games["game_id"].string ?? "-999"
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

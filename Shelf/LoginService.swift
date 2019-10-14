//
//  LoginService.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/13/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

func loginUser(username: String, password: String) {
    print("USER: " + username);
    print("PASS: " + password);
    
    let body: [String: String] = [
        "username": "alex123",
        "password": "password",
    ]
    AF.request("http://localhost:8080/user/login", method: .post, parameters: body, encoder: JSONParameterEncoder.default).responseJSON { response in
        switch response.result {
        case .success(let value):
            User.currentUser.initFromJson(json: value as AnyObject)
        
        case .failure(let error):
            print(error)
        }
        
    }

}


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
import KeychainSwift

    func loginUser(username: String, password: String) {
        print("USER: " + username);
        print("PASS: " + password);
        
        if (!usernameIsValid(username: username)) {return}
        if (!passwordIsValid(password: password, confirmPassword: password)) {return}

        let body: [String: String] = [
            "username": username,
            "password": password,
        ]
        print("trying")
        AF.request("http://localhost:8080/user/login", method: .post, parameters: body, encoder: JSONParameterEncoder.default).responseJSON { response in
            if response.response?.statusCode == 200 {
                print("success")
                
                if let token = response.response?.allHeaderFields["token"] as? String {
                    User.currentUser.setToken(token: token)
                }
                
                User.currentUser.initFromJson(json: response.value as AnyObject)
                let keychain = KeychainSwift()
                keychain.set(username, forKey: "username")
                keychain.set(password, forKey: "password")
                
            }
            else {
                print("fail")
                let error = JSON(response.data as Any)
                let errorMessage = error["message"].string
               
                ErrorHandler.errorHandler.errorMessageText = errorMessage!
                ErrorHandler.errorHandler.errorDetected = true
                        
            }
            
        }

    }


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

//class LoginService: ObservableObject {
    
   // @Published private var isLoggedIn: Bool = false;
    
    func loginUser(username: String, password: String) {
        print("USER: " + username);
        print("PASS: " + password);

        let body: [String: String] = [
            "username": username,
            "password": password,
        ]
        AF.request("http://localhost:8080/user/login", method: .post, parameters: body, encoder: JSONParameterEncoder.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                User.currentUser.initFromJson(json: value as AnyObject)
           //     self.isLoggedIn = true;
            
            case .failure(let error):
                print(error)
         //       self.isLoggedIn = false;
            }
            
        }
    

    }
//}


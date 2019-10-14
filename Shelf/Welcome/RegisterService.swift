//
//  RegisterService.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/13/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


func registerUser(username: String, password: String, email: String, birthday: Date) {
    print("USER: " + username);
    print("PASS: " + password);
    print("EMAIL: " + email);
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dateString = dateFormatter.string(from: birthday)
    print("BIRTHDAY: " + dateString);
    let body: [String: String] = [
        "username": username,
        "password": password,
        "email": email,
        "birthday": dateString
    ]
    AF.request("http://localhost:8080/user/register", method: .post, parameters: body, encoder: JSONParameterEncoder.default).responseJSON { response in
        switch response.result {
        case .success(let value):
            print(value);
        
        case .failure(let error):
            print(error)
        }
        
    }


}

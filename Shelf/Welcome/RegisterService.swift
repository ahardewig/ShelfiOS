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



func registerUser(username: String, password: String, confirmPassword: String, email: String, birthday: Date) {
      
    if (!usernameIsValid(username: username)) {return}
    if (!passwordIsValid(password: password, confirmPassword: confirmPassword)) {return}
    if (!emailIsValid(email: email)) {return}
        
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

func usernameIsValid(username: String) -> Bool {
    if (username.count == 0) {
        ErrorHandler.errorHandler.errorMessageText = "Please enter your username";
        ErrorHandler.errorHandler.errorDetected = true;
        return false;
    }
    
    return true;
}

func passwordIsValid(password: String, confirmPassword: String ) -> Bool {

    if (password != confirmPassword) {
        ErrorHandler.errorHandler.errorMessageText = "Passwords don't match";
        ErrorHandler.errorHandler.errorDetected = true;
        return false;
    }
    else if (password.count < 8) {
        ErrorHandler.errorHandler.errorMessageText = "Password must be at least 8 characters";
        ErrorHandler.errorHandler.errorDetected = true;
        return false;
    }

    return true;


}

func emailIsValid(email: String) -> Bool {
    if (email.count == 0) {
           ErrorHandler.errorHandler.errorMessageText = "Please enter your email";
           ErrorHandler.errorHandler.errorDetected = true;
           return false;
       }
    return true;
}


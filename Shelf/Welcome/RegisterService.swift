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


func verifyEmail(email: String, verificationNum: String) {
    
    let body: [String: String] = [
            "email": email,
            "verificationNum": verificationNum,
        ]
    AF.request(DOMAIN + "user/verify-email", method: .post, parameters: body, encoder: JSONParameterEncoder.default).responseJSON { response in
           
            if response.response?.statusCode == 200 {
//                print("Success with JSON: \(String(describing: response.data))")
                ErrorHandler.errorHandler.errorMessageText = "Success!"
                ErrorHandler.errorHandler.errorDetected = true
            }
            else {
                let error = JSON(response.data as Any)
                let errorMessage = error["message"].string
               
                ErrorHandler.errorHandler.errorMessageText = errorMessage!
                ErrorHandler.errorHandler.errorDetected = true
                        
            }
            
        }
    }
    


func registerUser(username: String, password: String, confirmPassword: String, email: String, birthday: Date) {
//    print (birthday)
    
    if (!usernameIsValid(username: username)) {return}
    if (!passwordIsValid(password: password, confirmPassword: confirmPassword)) {return}
    if (!emailIsValid(email: email)) {return}

//    print("USER: " + username);
//    print("PASS: " + password);
//    print("EMAIL: " + email);
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let dateString = dateFormatter.string(from: birthday)
//        print("BIRTHDAY: " + dateString);

        let body: [String: String] = [
            "username": username,
            "password": password,
            "email": email,
            "birthday": "1990-04-04"
        ]
    AF.request(DOMAIN + "user/register", method: .post, parameters: body, encoder: JSONParameterEncoder.default).responseJSON { response in
           
            if response.response?.statusCode == 200 {
//                print("Success with JSON: \(String(describing: response.data))")
            }
            else {
                let error = JSON(response.data as Any)
                let errorMessage = error["message"].string
               
                ErrorHandler.errorHandler.errorMessageText = errorMessage!
                ErrorHandler.errorHandler.errorDetected = true
                        
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


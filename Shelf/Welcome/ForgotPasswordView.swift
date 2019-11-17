//
//  ForgotPasswordView.swift
//  Shelf
//
//  Created by Ben Kahlert on 11/17/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI
import Foundation
import Alamofire
import SwiftyJSON

struct ForgotPasswordView: View {
    
    @Binding var isRegistering: Bool
    @Binding var isForgotPassword: Bool
    
    @State var email: String = ""
    @EnvironmentObject var errorHandler: ErrorHandler
    
    var body: some View {
        ZStack {
            VStack {
                VStack{
                    kHeader(text: "Forgot your password?");
                    kBody(text: "Enter your email below and we'll send you a temporary password")
                }
                ForgotPasswordEmailTextField(email: $email)
                Button(action: {self.resetPassword(email: self.email)}) {
                   ForgotPasswordButton()
                }
                Button(action: {self.isForgotPassword = false}) {
                    SwitchToLoginButton()
                }
            }.padding()
            .alert(isPresented: $errorHandler.errorDetected) {
                Alert(title: Text("Error!"), message: Text(errorHandler.errorMessageText), dismissButton: .default(Text("Got it!")))
            }
        }
    }
    
    func resetPassword(email: String) {
        let body: [String: String] = [ "email": email ]
        print("sending password reset")
        AF.request(DOMAIN + "user/forgot-password" , method: .post, parameters: body, encoder: JSONParameterEncoder.default).responseJSON { response in
            if response.response?.statusCode == 200 {
                self.isRegistering = false
                self.isForgotPassword = false
            }
            else {
                print("Failed to send the email")
                ErrorHandler.errorHandler.errorMessageText = "Something went wrong, please make sure you enter a valid Shelf email!"
                ErrorHandler.errorHandler.errorDetected = true
            }
            
        }
    }
}

struct ForgotPasswordEmailTextField: View {
    @Binding var email: String
    
    var body: some View {
        TextField("Email" , text: $email )
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .font(KarlaInput)
    }
}

struct ForgotPasswordButton: View {
    var body: some View {
        primaryCTAButton(text: "Reset password")
        
    }
}

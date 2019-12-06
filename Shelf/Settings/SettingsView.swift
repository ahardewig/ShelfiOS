//
//  SettingsView.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/13/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI
import Foundation
import Alamofire
import SwiftyJSON

struct SettingsView: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @State var password: String = ""
    @State var confirmPassword: String = ""
    
    @State var email: String = ""
    @State var confirmEmail: String = ""
    
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                VStack{
                    kHeader(text: "Settings");
                }
                kBody(text: "Change your password")
                EnterPasswordTextField(password: $password)
                ReenterPasswordTextField(confirmPassword: $confirmPassword)
                Button(action: {self.changePassword(password: self.password, confirmPassword: self.confirmPassword)}) {
                   ChangePasswordButton()
                }
                
                Spacer()
                
                kBody(text: "Change your email")
                NewEmailTextField(email: $email)
                ConfirmEmailTextField(confirmEmail: $confirmEmail)
                Button(action: {self.changeEmail(email: self.email, confirmEmail: self.confirmEmail)}) {
                   ChangeEmailButton()
                }

            }.padding()
            .alert(isPresented: $errorHandler.errorDetected) {
                Alert(title: Text("Error!"), message: Text(errorHandler.errorMessageText), dismissButton: .default(Text("Got it!")))
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Success!"), message: Text("Your change was successful!"), dismissButton: .default(Text("Got it!")))
            }
        }
    }
    
    func changePassword(password: String, confirmPassword: String) {
        if (password.count <= 7) {
            print("short password ERR")
            ErrorHandler.errorHandler.errorDetected = true
            ErrorHandler.errorHandler.errorMessageText = "Your password is too short. Please enter a password at least 8 characters long."
        } else {
            if (password == confirmPassword) {
                let headers: HTTPHeaders = [
                    "token": User.currentUser.getToken()
                ]
                let body: [String: String] = [ "password": password ]
                print("sending password change request")
                AF.request(DOMAIN + "user/change-password" , method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
                    if response.response?.statusCode == 200 {
                        self.showAlert = true
                    }
                    else {
                        print("Failed update password")
                        ErrorHandler.errorHandler.errorDetected = true
                        ErrorHandler.errorHandler.errorMessageText = "Something went wrong, please try again."
                    }
                }
            } else {
                print("Non matching passwords ERR")
                ErrorHandler.errorHandler.errorDetected = true
                ErrorHandler.errorHandler.errorMessageText = "Your passwords don't match. Please enter them again."
            }
        }
    }
    
    func changeEmail(email: String, confirmEmail: String) {
        if (email == confirmEmail) {
            let headers: HTTPHeaders = [
                "token": User.currentUser.getToken()
            ]
            let body: [String: String] = [ "email": email ]
            print("sending email change request")
            AF.request(DOMAIN + "user/change-email" , method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
                if response.response?.statusCode == 200 {
                    self.showAlert = true
                }
                else {
                    print("Failed email password")
                    ErrorHandler.errorHandler.errorDetected = true
                    ErrorHandler.errorHandler.errorMessageText = "Something went wrong, that email may already be taken."
                }
            }
        } else {
            print("Non matching emails ERR")
            ErrorHandler.errorHandler.errorDetected = true
            ErrorHandler.errorHandler.errorMessageText = "Your emails don't match. Please enter them again."
        }
    }
    
}

struct EnterPasswordTextField: View {
    @Binding var password: String
    var body: some View {
        SecureField("Enter new password", text: $password)
        .padding()
        .background(lightGreyColor)
        .cornerRadius(5.0)
        .padding(.bottom, 20)
        .font(KarlaInput)
    }
}

struct ReenterPasswordTextField: View {
    @Binding var confirmPassword: String
    var body: some View {
        SecureField("Re-enter new password" , text: $confirmPassword )
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .font(KarlaInput)
    }
}

struct NewEmailTextField: View {
    @Binding var email: String
    var body: some View {
        TextField("Enter new email", text: $email)
        .padding()
        .background(lightGreyColor)
        .cornerRadius(5.0)
        .padding(.bottom, 20)
        .font(KarlaInput)
    }
}

struct ConfirmEmailTextField: View {
    @Binding var confirmEmail: String
    var body: some View {
        TextField("Confirm new email", text: $confirmEmail)
        .padding()
        .background(lightGreyColor)
        .cornerRadius(5.0)
        .padding(.bottom, 20)
        .font(KarlaInput)
    }
}

struct ChangePasswordButton: View {
    var body: some View {
        primaryCTAButton(text: "Change Password")
    }
}

struct ChangeEmailButton: View {
    var body: some View {
        primaryCTAButton(text: "Change Email")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

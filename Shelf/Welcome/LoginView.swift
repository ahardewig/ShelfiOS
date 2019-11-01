//
//  LoginView.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/13/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI
import KeychainSwift
import LocalAuthentication

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

struct LoginView: View {
    
    @Binding var isRegistering: Bool;
    
    @State var username: String = ""
    @State var password: String = ""
    @EnvironmentObject var errorHandler: ErrorHandler
    
   var body: some View {
    ZStack {
        VStack {
            ShelfImage()
            LoginText()
            UsernameTextField(username: $username)
            PasswordTextField(password: $password)
            Button(action: {loginUser(username: self.username, password: self.password)}) {
               LoginButton()
            }
            
            Button(action: {self.isRegistering = true}) {
                  SwitchToSignupButton()
            }
            Button(action: {faceId()}) {
                HStack {
                    secondaryCTAButton(text: "Log In with FaceID")
                    Image(systemName: "faceid").accentColor(.black).imageScale(.large).offset(y: CGFloat(8))
                }
                
            }
            
        }.padding()
        
        .alert(isPresented: $errorHandler.errorDetected) {
            Alert(title: Text("Attention!"), message: Text(errorHandler.errorMessageText), dismissButton: .default(Text("Got it!")))
        }

    }
    }
}

func faceId() {
    print("entering")
    let laContext = LAContext()
    var error: NSError?
    let biometricsPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics

    if (laContext.canEvaluatePolicy(biometricsPolicy, error: &error)) {

        if let laError = error {
            ErrorHandler.errorHandler.errorDetected = true;
            ErrorHandler.errorHandler.errorMessageText = "\(laError)"
            return
        }

        var localizedReason = "Unlock device"
        if #available(iOS 11.0, *) {
            switch laContext.biometryType {
            case .faceID: localizedReason = "Face ID Unlock";
            case .touchID: localizedReason = "Touch ID Unlock";
            case .none: localizedReason = "No support"
            @unknown default:
                fatalError();
            }
        } else {
            // do other stuff but we only support ios13 so no need to do
        }


        laContext.evaluatePolicy(biometricsPolicy, localizedReason: localizedReason, reply: { (isSuccess, error) in

            DispatchQueue.main.async(execute: {

                if let laError = error {
                    ErrorHandler.errorHandler.errorDetected = true;
                    ErrorHandler.errorHandler.errorMessageText = "\(laError)"
                } else {
                    if isSuccess {
                        let keychain = KeychainSwift()
                        let username = keychain.get("username");
                        let password = keychain.get("password");
                        if ((username?.count ?? 0 > 0) && (password?.count ?? 0 > 0)) {
                            loginUser(username: username ?? "" , password: password ?? "" )
                        }
                        else {
                            ErrorHandler.errorHandler.errorDetected = true
                             ErrorHandler.errorHandler.errorMessageText = "No saved credentials. Log in normally first!"
                        }
                    } else {
                        ErrorHandler.errorHandler.errorDetected = true
                        ErrorHandler.errorHandler.errorMessageText = "No saved credentials. Log in normally first!"
                    }
                }

            })
        })
    }
}

struct LoginText: View {
    var body: some View {
        VStack{
            kHeader(text: "Welcome Back!");
            kBody(text: "Login to pick up where you left off.")
        }
        
    }
}

struct ShelfImage: View {
    var body: some View {
        Image("Group 5")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 50)
            .padding(.bottom, 35)
    }
}

struct LoginButton: View {
    var body: some View {
        primaryCTAButton(text: "LOGIN")
        
    }
}

struct SwitchToSignupButton: View {
    var body: some View {
        secondaryCTAButton(text: "Register for an Account")
    }
}

struct UsernameTextField: View {
    @Binding var username: String
    
    var body: some View {
        TextField("Username" , text: $username )
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .font(KarlaInput)
    }
}

struct PasswordTextField: View {
    @Binding var password: String
    var body: some View {
        SecureField("Password", text: $password)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .font(KarlaInput)
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        
        LoginView(isRegistering: .constant(false)).environmentObject(ErrorHandler.errorHandler)
    }
}

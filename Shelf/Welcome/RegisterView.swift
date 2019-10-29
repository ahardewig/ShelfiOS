//
//  RegisterView.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/13/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    
    @Binding var isRegistering: Bool;
    
    @State var username: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var email: String = ""
    @State var birthday = Date()
    @EnvironmentObject var errorHandler: ErrorHandler
    @State private var isVerifyingAccount: Bool = false
    
//    Font information
    let KarlaRegular = Font.custom("Karla", size: 24);
    
    var body: some View {
    
        ZStack {
            VStack {
                RegisterText()
                UsernameTextField(username: $username)
                    .padding(.top)
                PasswordTextField(password: $password)
                ConfirmPasswordTextField(confirmPassword: $confirmPassword)
                EmailTextField(email: $email)
//                DatePicker(
//                    selection: $birthday,
//                    in: ...Date(),
//                    displayedComponents: .date,
//                    label: { Text("DOB").font(KarlaInput) }
//                ).font(KarlaInput)
                
                Button(action: {registerUser(username: self.username, password: self.password, confirmPassword: self.confirmPassword, email: self.email, birthday: self.birthday)}) {
                   SignupButton()
                }
                
                Button(action: {self.isRegistering = false}) {
                      SwitchToLoginButton()
                }
                Spacer()
                Button(action: {
                    print("Button Pushed")
                    self.isVerifyingAccount = true
                    
                }) {
                   VerifyButton()
                }.sheet(isPresented: self.$isVerifyingAccount) {
                    VerifyModal()
                }
                
            }.padding()
                .alert(isPresented: $errorHandler.errorDetected) {
                    Alert(title: Text("Error!"), message: Text(errorHandler.errorMessageText), dismissButton: .default(Text("Got it!")))
                }
        }
        .background(Color(red: 248, green: 247, blue: 251, opacity: 1.0))
        
    }
    
    
}


struct VerifyModal: View {
    @Environment(\.presentationMode) var presentationMode
    @State var email: String = ""
    @State var verificationNum: String = ""
    
    var body: some View {
        VStack {
            Group() {
                EmailVerifyTextField(email: $email).autocapitalization(.none)
                VerifyNumberTextField(verificationNum: $verificationNum)
                Button(action: {
                    verifyEmail(email: self.email, verificationNum: self.verificationNum)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    SubmitVerifyButton()
                }.padding(.bottom, 50)
            }
            
        }
    }
}



struct SwitchToLoginButton: View {
    var body: some View {
        secondaryCTAButton(text: "Switch to Login")
    }
}

struct RegisterText: View {
    
    var body: some View {
        VStack {
            Text("Register for Shelf")
                .font(KarlaHeader)
                .fontWeight(.semibold)
                .padding(.bottom, 8)
            Text("We're excited you're here! Input the following information to get started using Shelf.")
                .font(KarlaBody)
                .multilineTextAlignment(.center)
            
        }
        
        
    }
}

struct ConfirmPasswordTextField: View {
    @Binding var confirmPassword: String
    var body: some View {
        SecureField("Confirm Password", text: $confirmPassword)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .font(KarlaInput)
    }
}

struct EmailTextField: View {
    @Binding var email: String
    var body: some View {
        TextField("Email Address", text: $email)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .font(KarlaInput)
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(isRegistering: .constant(true)).environmentObject(ErrorHandler.errorHandler)
    }
}

struct SignupButton: View {
    var body: some View {
        primaryCTAButton(text: "REGISTER")
    }
}

struct VerifyButton: View {
    var body: some View {
        primaryCTAButton(text: "VERIFY ACCOUNT")
    }
}

struct SubmitVerifyButton: View {
    var body: some View {
        primaryCTAButton(text: "SUBMIT")
    }
}

struct EmailVerifyTextField: View {
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

struct VerifyNumberTextField: View {
    @Binding var verificationNum: String
    
    var body: some View {
        TextField("Verification Number" , text: $verificationNum )
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .font(KarlaInput)
    }
}

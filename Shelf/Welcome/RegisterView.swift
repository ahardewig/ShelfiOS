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
    
    
    var body: some View {
    
        VStack {
            RegisterText()
            UsernameTextField(username: $username)
            PasswordTextField(password: $password)
            ConfirmPasswordTextField(confirmPassword: $confirmPassword)
            EmailTextField(email: $email)
            DatePicker(
                selection: $birthday,
                in: ...Date(),
                displayedComponents: .date,
                label: { Text("DOB") }
            )
            Button(action: {signup(username: self.username, password: self.password, email: self.email, birthday: self.birthday)}) {
               SignupButton()
            }
            
            Button(action: {self.isRegistering = false}) {
                  SwitchToLoginButton()
            }
        }.padding()
        
    }
}

func signup(username: String, password: String, email: String, birthday: Date) {
    print(username)
    print(password)
    //print("my birthday: " + birthday)
    registerUser(username: username,password: password, email: email, birthday: birthday)

}

struct SwitchToLoginButton: View {
    var body: some View {
        Text("Log into my Account!")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 320, height: 60)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}

struct RegisterText: View {
    var body: some View {
        Text("Register for Shelf!")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
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
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(isRegistering: .constant(false))
    }
}

struct SignupButton: View {
    var body: some View {
        Text("Sign up!")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 320, height: 60)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}

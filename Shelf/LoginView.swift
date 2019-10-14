//
//  LoginView.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/13/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

struct LoginView: View {
    @State var username: String = "";
    @State var password: String = ""
    @State var authenticationDidFail: Bool = false
    @State var authenticationDidSucceed: Bool = false
    
    
    
    
   var body: some View {
    ZStack {
        VStack {
            WelcomeText()
            ShelfImage()
            UsernameTextField(username: $username)
            PasswordTextField(password: $password)
            if authenticationDidFail {
                Text("Information not correct. Try again.")
                .offset(y: -10)
                .foregroundColor(.red)
            }
            Button(action: {doThis(username: self.username, password: self.password)}) {
               LoginButton()
            }
        }.padding()

        if authenticationDidSucceed {
           Text("Login succeeded!")
            .font(.headline)
            .frame(width: 250, height: 80)
            .background(Color.green)
            .cornerRadius(20.0)
            .foregroundColor(.white)
            .animation(Animation.default)
        }
        }
    }
}

func doThis(username: String, password: String) {
    print(username);
    print(password);
    loginUser(username: username,password: password)
    
}

struct WelcomeText: View {
    var body: some View {
        Text("Welcome!")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

struct ShelfImage: View {
    var body: some View {
        Image("second")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(150)
            .padding(.bottom, 75)
    }
}

struct LoginButton: View {
    var body: some View {
        Text("LOGIN")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.green)
            .cornerRadius(15.0)
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
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

//
//  FindFriendView.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/13/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct FindFriendView: View {
    
    @State var users: [UserOverview] = []
    
    let url = "http://localhost:8080/user/all-users"
    
    var body: some View {
        VStack {
            //Text("Message your friends!")
            //NavigationView {
                List(users, id: \.username) { user in
//                    NavigationLink(destination: MessagingView(to: user)) {
//                        Text("MESSAGE THIS USER: " + user.username)
//                    }
                    NavigationLink(destination: ProfileView(username: user.username)) {
                        Text("MESSAGE THIS USER: " + user.username)
                    }
                }
           // }
        }.onAppear { self.getAllUsers() }
    }
    
    func getAllUsers() {
        let headers: HTTPHeaders = [
            "token": User.currentUser.getToken()
        ]
        AF.request(url, headers: headers).responseJSON { response in
            if response.response?.statusCode == 200 {
                self.parseAllUserData(response: response.value as Any);
            } else {
                let error = JSON(response.data as Any)
                let errorMessage = error["message"].string
                print(errorMessage as Any)
            }
        }
    }
    
    func parseAllUserData(response: Any) {
        let sampleJson = JSON(response)
        let responseArray = sampleJson.array
        users = [];
        for user in responseArray! {
            let newUser = UserOverview(user: user)
            users.append(newUser)
        }
    }
}

struct FindFriendView_Previews: PreviewProvider {
    static var previews: some View {
        FindFriendView()
    }
}

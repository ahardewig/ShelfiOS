//
//  MessagingView.swift
//  Shelf
//
//  Created by Ben Kahlert on 10/26/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import Foundation
import SwiftUI
import Alamofire
import SwiftyJSON

struct MessagingView: View {
    
    @State var to: UserOverview
    @State var messages: [Message] = []
    
    let url = "http://localhost:8080/message/all"
    
    var body: some View {
        VStack {
            Text("MESSAGING TO " + to.username)
            ForEach (messages, id: \.id) { message in
                Text("Message from " + message.sender + ": " + message.message)
            }
        }.onAppear { self.getAllMessages() }
    }
    
    func getAllMessages() {
        let headers: HTTPHeaders = [
            "token": User.currentUser.getToken(),
            "receiver": to.username
        ]
        AF.request(url, headers: headers).responseJSON { response in
            if response.response?.statusCode == 200 {
                self.parseMessageData(response: response.value as Any);
            } else {
                let error = JSON(response.data as Any)
                let errorMessage = error["message"].string
                print(errorMessage as Any)
            }
        }
    }
    
    func parseMessageData(response: Any) {
        print ("Getting the resposne data!")
        let sampleJson = JSON(response)
        let messageArray = sampleJson["messages"].array ?? []
        
        for message in messageArray {
            let newMessage = Message(message: message)
            messages.append(newMessage)
        }
    }
}

struct Messaging_Previews: PreviewProvider {
    static var previews: some View {
        MessagingView(to: UserOverview())
    }
}

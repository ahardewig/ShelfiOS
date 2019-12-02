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
    
    @State var to: String
    @State var messages: [Message] = []
    @State var message: String = ""
    @State var _id: String = ""
    
    let url = DOMAIN + "message/all"
    let sendUrl = DOMAIN + "message/send"
    let newUrl = DOMAIN + "message/new"
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .center){
                MessageTextField(message: $message)
                Button(action: { self.sendMessage() }) {
                   SendMessageButton()
                }
            }
            List{
                ForEach (messages, id: \.id) { message in
                    profileSmall(text: message.sender + ": " + message.message)
                }
            }
            
            Spacer()
            
            }.padding(16)
            .navigationBarTitle("Messages with \(to)")
        .onAppear { self.getAllMessages() }
    }
    
    func getAllMessages() {
        let headers: HTTPHeaders = [
            "token": User.currentUser.getToken(),
            "receiver": to
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
        let sampleJson = JSON(response)
        if (!sampleJson["_id"].exists()) {
            let headers: HTTPHeaders = [
                "token": User.currentUser.getToken()
            ]
            let body: [String: String] = [
                "firstUser": User.currentUser.getUsername(),
                "secondUser": to,
            ]
            AF.request(newUrl, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { resp in
                if resp.response?.statusCode == 200 {
                    self.messages = []
                    let messagesJson = JSON(resp)
                    self._id = messagesJson["_id"].string ?? ""
                } else {
                    let error = JSON(resp.data as Any)
                    let errorMessage = error["message"].string
                    print(errorMessage as Any)
                }
            }
        } else {
            _id = sampleJson["_id"].string ?? ""
            let messageArray = sampleJson["messages"].array ?? []
            
            messages = []
            for message in messageArray {
                let newMessage = Message(message: message)
                print (newMessage.message)
                messages.append(newMessage)
            }
        }
    }
    
    func sendMessage() {
        let headers: HTTPHeaders = [
            "token": User.currentUser.getToken()
        ]
        let body: [String: String] = [
            "message": message,
            "messageID": _id,
        ]
        AF.request(sendUrl, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
            if response.response?.statusCode == 200 {
                self.message = ""
                self.getAllMessages()
            } else {
                let error = JSON(response.data as Any)
                let errorMessage = error["message"].string
                print(errorMessage as Any)
            }
        }
    }
}

struct MessageTextField: View {
    @Binding var message: String
    
    var body: some View {
        TextField("Message" , text: $message )
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .font(KarlaInput)
    }
}

struct SendMessageButton: View {
    var body: some View {
        primaryCTAButton(text: "Send")
        
    }
}

//
//  AllMessagesView.swift
//  Shelf
//
//  Created by Ben Kahlert on 10/26/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import Foundation
import SwiftUI
import Alamofire
import SwiftyJSON

struct AllMessagesView: View {
    
    let url = DOMAIN + "user/all-messages"
    @State var people: [String] = [];
    
    var body: some View {
        VStack(alignment: .leading) {
            List(people, id: \.self) { user in
                NavigationLink(destination: MessagingView(to: user)) {
                    profileSmall(text: user)
                }
            }
        }.padding(16)
        .navigationBarTitle("Conversations")
        .onAppear { self.getAllConversations() }
    }
    
    func getAllConversations() {
        let headers: HTTPHeaders = [
            "token": User.currentUser.getToken()
        ]
        AF.request(url, headers: headers).responseJSON { response in
            if response.response?.statusCode == 200 {
                self.parseAllMessagesData(response: response.value as Any);
            } else {
                let error = JSON(response.data as Any)
                let errorMessage = error["message"].string
                print(errorMessage as Any)
            }
        }
    }
    
    func parseAllMessagesData(response: Any) {
        let sampleJson = JSON(response)
        print (sampleJson)
        let messageArray = sampleJson.array ?? []
        
        people = []
        
        for message in messageArray {
            let messageJson = JSON(message)
            let messagesArray = messageJson["messages"].array ?? [];
            
            if (messagesArray.count != 0) {
                var name = messageJson["firstUser"].string ?? ""
                if (name == User.currentUser.getUsername()) {
                    name = messageJson["secondUser"].string ?? ""
                }
                print(name)
                people.append(name)
            }
        }
        
        print ("Parsed messages!")
    }
}

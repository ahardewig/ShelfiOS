//
//  NotificationsView.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/13/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import Foundation
import SwiftUI
import Alamofire
import SwiftyJSON

struct NotificationsView: View {
    
    let addNotificationUrl = DOMAIN + "inbox/add-notification"
    let getInboxUrl = DOMAIN + "inbox/all-notifications"
    let markAsReadUrl = DOMAIN + "inbox/mark-as-read"
    
    @State var notifications: [Notification] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            // Zach, below is where the notifications get displayed. I am unable to figure out how to display the sender and timestamp above the notification (in bold like on the website) and the icon. the notifications[] contains all the information
            List{
                ForEach (notifications, id: \.id) { notificationText in
                    notificationSmall(text: notificationText.message, u: notificationText.sender, d: notificationText.timeStamp)
                    
                }
            }
            
            Spacer()
            
            }.padding(16)
            .navigationBarTitle("Notifications")
        .onAppear { self.getInbox() }
    }
    
    func getInbox() {
        let headers: HTTPHeaders = [
            "token": User.currentUser.getToken()
        ]
        AF.request(getInboxUrl, headers: headers).responseJSON {
            response in
            if response.response?.statusCode == 200 {
                self.displayInbox(response: response.value as Any)
            } else {
                let error = JSON(response.data as Any)
                let errorMessage = error["message"].string
                print(errorMessage as Any)
            }
        }
    }
    
    func displayInbox(response: Any) {
        let sample = JSON(response)
        let notificationsArray = sample["notification"].array ?? []
//        print(notificationsArray)
                
        notifications = []
        
        for notification in notificationsArray {
            let message = notification["message"].string ?? ""
            if message.contains("message") {
                let notificationText = Notification(json: notification, type: "message")
                notifications.append(notificationText)
            } else {
                let notificationText = Notification(json: notification, type: "follower")
                notifications.append(notificationText)
            }
        }
    }
}

struct notificationSubtitle: View {
    var text1: String;
    var body: some View {
        Text(text1)
            .font(KarlaButton).fontWeight(.bold)
            .padding(.bottom, 8)
            .padding(.top, 32)
    }
    
    init(text: String){
        text1 = text
    }
}

struct notificationSmall: View {
    var text1: String;
    var username: String;
    var date: String;
    var body: some View {
        HStack{
            Circle().frame(width: 20, height: 20)
                .padding(0)
                .foregroundColor(Color(red: 0.98, green: 0.65, blue: 0.10, opacity: 1.0))
                
            VStack(alignment: .leading){
                HStack{
                    Text(username).font(KarlaInput)
                    Text(date.prefix(10)).font(KarlaTiny)
                }
                Text(text1)
                    .font(KarlaBody).fontWeight(.bold)
            }
           
        }
        
        
    }
    
    init(text: String, u: String, d: String){
        text1 = text
        username = u;
        date = d;
    }
}

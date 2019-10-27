//
//  StarRatingView.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/24/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct StarRatingView: View {
    
    @Binding var games: [GameOverview];
    @State var gameId: Int;
    @State var canEdit: Bool;
    

    func starButton(index:Int) -> some View {
    
        var imageName: String = "star"
        var color: Color = .gray
            
        for game in games {
            //find correct game
            if (game.id == gameId) {
                if (canEdit) {
                    print("USER: \(game.userRating)")
                    imageName = index <= game.userRating ? "star.fill" : "star"
                    color = index <= game.userRating ? .yellow : .gray
                    
                }
                else {
                     imageName = index <= game.globalRating ? "star.fill" : "star"
                     color = .gray
                }
                
                break;
            }
        }

      return
        Button(action: {
            if (self.canEdit) {

            }
           
            
            
        }) {
          Image(systemName:imageName)
            .imageScale(.large)
            .foregroundColor(color)
            .frame(width:24, height: 24)
      }
    }
    
    var body: some View {
        HStack {
          ForEach(1...5,id: \.self ) { id in
            self.starButton(index: id)
          }
        }
    }
}



struct UserRatingView: View {
    
    @Binding var userRating: Int;
    @State var canEdit: Bool;
    @Binding var gameId: Int;
    

    func starButton(index:Int) -> some View {
    
        var imageName: String = "star"
        var color: Color = .gray
            //find correct game
        if (canEdit) {
            print("USER: \(userRating)")
            imageName = index <= userRating ? "star.fill" : "star"
            color = index <= userRating ? .yellow : .gray
                    
        }
        else {
            imageName = index <= userRating ? "star.fill" : "star"
            color = .gray
        }
                
      return
        Button(action: {
            if (self.canEdit) {
                self.submitRatingToUser(newRating: index, oldRating: self.userRating, gameId: self.gameId)
                self.submitRatingToGame(newRating: index, oldRating: self.userRating, gameId: self.gameId)
                if (self.userRating == index) {
                    self.userRating = 0
                }
                else {
                    self.userRating = index;
                }
            }
           
            
        }) {
          Image(systemName:imageName)
            .imageScale(.large)
            .foregroundColor(color)
            .frame(width:24, height: 24)
      }
    }
    
    
    
    func submitRatingToUser(newRating: Int, oldRating: Int, gameId: Int) {
        let headers: HTTPHeaders = [
                   "token": User.currentUser.getToken()
               ]
               let body: [String: Int] = [
                   "gameId": gameId,
                   "newRating": newRating,
                   "oldRating": oldRating
               ]
        AF.request(DOMAIN + "user/\(User.currentUser.getUsername())/games-rated",
                           method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
                    if response.response?.statusCode == 200 {
                        print(response.value as Any)
                    } else {
                        let error = JSON(response.data as Any)
                        let errorMessage = error["message"].string
                        print(errorMessage as Any)
                    }
                    
                }
    }
    
    func submitRatingToGame(newRating: Int, oldRating: Int, gameId: Int) {
        
        let headers: HTTPHeaders = [
                   "token": User.currentUser.getToken()
               ]
               let body: [String: Int] = [
                   "gameId": gameId,
                   "newRating": newRating,
                   "oldRating": oldRating
               ]
        AF.request(DOMAIN + "ratingInfo/\(gameId)",
                           method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
                    if response.response?.statusCode == 200 {
                        print(response.value as Any)
                    } else {
                        let error = JSON(response.data as Any)
                        let errorMessage = error["message"].string
                        print(errorMessage as Any)
                    }
                    
                }
        
    }
    
    var body: some View {
        HStack {
          ForEach(1...5,id: \.self ) { id in
            self.starButton(index: id)
          }
        }
    }
}





enum Rating: Int,CaseIterable {
  case zero = 0
  case one
  case two
  case three
  case four
  case five

}

//struct StarRatingView_Previews: PreviewProvider {
//    static var previews: some View {
//        StarRatingView()
//    }
//}

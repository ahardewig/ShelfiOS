//
//  StarRatingView.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/24/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI

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

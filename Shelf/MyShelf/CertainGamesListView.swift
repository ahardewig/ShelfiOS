//
//  FollowersDetailedView.swift
//  Shelf
//
//  Created by Zach Johnson on 10/28/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI
import URLImage

struct CertainGamesListView: View {
    @ObservedObject var profile: User
    @Binding var gamesRated: [Game];
    
    var body: some View {
        VStack(alignment: .leading){
                List(content: {
                         
                      ForEach(gamesRated) { game in
                          
                          URLImage(URL(string: game.coverId )!,
                              processors: [ Resize(size: CGSize(width: 100.0, height: 150.0), scale: UIScreen.main.scale) ],
                              content: {
                                  $0.image
                             .resizable()
                             .aspectRatio(contentMode: .fill)
                             .clipped()
                             }).frame(width: 100, height: 150)
                         }
                         
                     .frame(height: 150)
                })
            
            
            Spacer()
                .navigationBarTitle("\(profile.getUsername())'s Rated Games")
        }.padding(16)
    }
}



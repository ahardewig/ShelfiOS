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
    @State var showSortingSheet: Bool = false
    @State var currentSortingMethod: SortingEnum = SortingEnum.UserDescending
    //@State var isLoading: Bool = true;
    
    var body: some View {
        //VStack {
            HStack {
                List(self.gamesRated.sorted(by: self.customSorter), id: \.id) { game in

                    Group() {
                          URLImage(URL(string: game.coverId )!,
                              processors: [ Resize(size: CGSize(width: 100.0, height: 150.0), scale: UIScreen.main.scale) ],
                              content: {
                                  $0.image
                             .resizable()
                             .aspectRatio(contentMode: .fill)
                             .clipped()
                             }).frame(width: CGFloat(100), height: CGFloat(150))
                         
                        VStack(alignment: .leading) {
                            //kSubtitle(text: game.name)
                            StarRatingNoVote(userRating: game.rating)
                        }
                      
                      }
                }
                     //.frame(height: 150)
                

            }.navigationBarItems(trailing: SortingSheetView(showSortingSheet: $showSortingSheet, currentSortingMethod: $currentSortingMethod))
    }
    
    
    func customSorter(this:Game, that:Game) -> Bool {

        switch currentSortingMethod {
            case .UserAscending:
                return this.rating < that.rating
        default:
                return this.rating > that.rating
        }
    }
}
            //Spacer()
                //.navigationBarTitle("\(profile.getUsername())'s Rated Games")
       // }.padding(16)



//
//  HomeView.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/10/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI
import URLImage
import Alamofire
import SwiftyJSON

struct HomeView: View {
    
    @State var games: [GameOverview] = []
    @State var showSortingSheet: Bool = false
    @State var currentSortingMethod: SortingEnum = SortingEnum.GlobalDescending
    @State var isLoading: Bool = true;
    let url = "https://images.igdb.com/igdb/image/upload/t_cover_big/"

    
    var body: some View {
            
            HStack {
                LoadingView(isShowing: $isLoading) {
                    List(self.games.sorted(by: self.customSorter), id: \.id) { game in
                        NavigationLink(destination: DetailedGameView(gameOverview: game, detailedGame: DetailedGame())) {
                            URLImage(URL(string: self.url + game.coverImageId + ".jpg")!,
                                     processors: [ Resize(size: CGSize(width: 100.0, height: 150.0), scale: UIScreen.main.scale) ],
                                content: {
                                    $0.image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            }).frame(width: 100, height: 150)

                            VStack(alignment: .leading) {
                                kSubtitle(text: game.name)
                                StarRatingView(games: self.$games, gameId: game.id, canEdit: false)
                            }
                        }
                    }.navigationBarTitle(Text("Global Games").font(KarlaHeader))
                
            }.onAppear {
                self.isLoading = true;
                self.getGames(username: User.currentUser.getUsername())
                    
                }.font(KarlaBody).frame(height: 675).navigationBarItems(leading:
                    HStack {
                        NavigationLink(destination: NotificationsView()){
                                           Image("Notification")
                                       }
                        NavigationLink(destination: SettingsView()){
                            Image("settings")
                        }
                    }
                   , trailing: SortingSheetView(showSortingSheet: $showSortingSheet, currentSortingMethod: $currentSortingMethod))
        }
    }
    
    func refreshUser() {
            let headers: HTTPHeaders = [
                       "token": User.currentUser.getToken()
                   ]
                   let body: [String: String] = [
                    "username": User.currentUser.getUsername(),
                   ]
            
            AF.request(DOMAIN + "user/data",
                               method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
                        if response.response?.statusCode == 200 {
                            User.currentUser.initFromJson(json: response.value as AnyObject)
                        } else {
                            let error = JSON(response.data as Any)
                            let errorMessage = error["message"].string
                            print(errorMessage as Any)
                        }
                        
                    }
    }
    
    func customSorter(this:GameOverview, that:GameOverview) -> Bool {

        switch currentSortingMethod {
            
            case .GlobalAscending:
                return this.globalRating < that.globalRating
            case .UserAscending:
            
                return this.userRating < that.userRating
            case .UserDescending:
                return this.userRating > that.userRating
            default:
                return this.globalRating > that.globalRating
        }
    }
    
    func getGames(username: String) {
   
        let headers: HTTPHeaders = [
            "token": User.currentUser.getToken()
        ]
        AF.request(DOMAIN + "games/criticallyacclaimedgames/\(username)",
                   headers: headers).responseJSON { response in
            if response.response?.statusCode == 200 {
                self.getGameOverviewsArray(response: response.value as Any)
                self.refreshUser()
                self.isLoading = false;
             
            } else {
                let error = JSON(response.data as Any)
                let errorMessage = error["message"].string
                print(errorMessage as Any)
                self.isLoading = false;
            }
            
        }
    }
    
    func getGameOverviewsArray(response: Any) {
        let sampleJson = JSON(response)
        let responseArray = sampleJson.array
        games = [];
        var temp: [GameOverview] = [];
        for game in responseArray! {
            let newGame = GameOverview(game: game)
            temp.append(newGame)
        }
        games = temp.sorted(by: customSorter)
    }
    
}

enum SortingEnum {
    case GlobalAscending
    case GlobalDescending
    case UserAscending
    case UserDescending
}

struct RandomText: View {
    var body: some View {
        Text("This is random text!")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

struct RandomButton: View {
    var body: some View {
        Text("GET THE GAMES")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 320, height: 60)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
 
            ZStack(alignment: .center) {

                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }

}

struct SortingSheetView: View {
    @Binding var showSortingSheet: Bool
    @Binding var currentSortingMethod: SortingEnum
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Sorting"), message: Text("Choose Option"), buttons: [
            .default(Text("Global Descending"), action: {
                self.showSortingSheet.toggle()
                self.currentSortingMethod = SortingEnum.GlobalDescending
                
            }),
            .default(Text("Global Ascending"), action: {
                self.showSortingSheet.toggle()
                self.currentSortingMethod = SortingEnum.GlobalAscending
            }),
            .default(Text("User Descending"), action: {
                self.showSortingSheet.toggle()
                self.currentSortingMethod = SortingEnum.UserDescending
            }),
            .default(Text("User Ascending"), action: {
                self.showSortingSheet.toggle()
                self.currentSortingMethod = SortingEnum.UserAscending
            }),
            
        ])
    }
    
    
    var body: some View {
        
        Button(action: {
            self.showSortingSheet.toggle()
        }) {
            Image(systemName:"arrow.up.arrow.down.circle.fill")
                .imageScale(.large)
                .frame(width:24, height: 24).foregroundColor(.black)
        }
        .actionSheet(isPresented: $showSortingSheet, content: {
            self.actionSheet })
    }
}

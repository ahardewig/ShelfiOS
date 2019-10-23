//
//  DetailedGameView.swift
//  Shelf
//
//  Created by Ben Kahlert on 10/23/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI

struct DetailedGameView: View {
    @State var name: String;
    var body: some View {
        Text("Name is \(name)")
    }
}

struct DetailedGameView_Previews: PreviewProvider {
    
    static var previews: some View {
        DetailedGameView(name: "FakeForPreview")
    }
}

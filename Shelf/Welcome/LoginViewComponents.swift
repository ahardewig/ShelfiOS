//
//  LoginViewComponents.swift
//  Shelf
//
//  Created by Zach Johnson on 10/22/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import SwiftUI

// Fonts
let KarlaHeader = Font.custom("Karla", size: 32);
let KarlaSubtitle = Font.custom("Karla", size: 16)
let KarlaInput = Font.custom("Karla", size: 18)

struct LoginViewComponents: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello World!"/*@END_MENU_TOKEN@*/)
    }
}

struct kHeader: View {
    var text1: String;
    var body: some View {
        Text(text1)
            .font(KarlaHeader)
            .fontWeight(.semibold)
            .padding(.bottom, 8)
    }
    
    init(text: String){
        text1 = text
    }
}

struct kSubtitle: View {
    var text1: String;
    var body: some View {
        Text(text1)
            .font(KarlaSubtitle)
            .padding(.bottom, 8)
    }
    
    init(text: String){
        text1 = text
    }
}

struct primaryCTAButton: View {
    var text1: String;
    var body: some View {
        Text("Register")
            .font(KarlaSubtitle)
            .foregroundColor(.white)
            .padding()
            .frame(width: 320, height: 60)
            .background(Color(red: 0.98, green: 0.65, blue: 0.10, opacity: 1.0))
            .cornerRadius(15.0)
    }
    
    init(text: String){
        text1 = text
    }
}

struct LoginViewComponents_Previews: PreviewProvider {
    static var previews: some View {
        LoginViewComponents()
    }
}

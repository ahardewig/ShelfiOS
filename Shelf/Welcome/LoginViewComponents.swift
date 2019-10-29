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
let KarlaBody = Font.custom("Karla", size: 16)
let KarlaInput = Font.custom("Karla", size: 18)
let KarlaButton = Font.custom("Karla", size: 23)
let KarlaTiny = Font.custom("Karla", size: 13)

struct LoginViewComponents: View {
    var body: some View {
        profileSmall(text: "zachzach")
    }
}

struct genreLabel: View {
    var text1: String;
    var body: some View {
        Text(text1)
        .font(KarlaTiny)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(red: 0.98, green: 0.65, blue: 0.10, opacity: 1.0), lineWidth: 1)
        )
    }
    
    init(text: String){
        text1 = text
    }
}

struct profileSmall: View {
    var text1: String;
    var body: some View {
        HStack{
            Circle().frame(width: 20, height: 20)
                .padding(0)
                .foregroundColor(Color(red: 0.98, green: 0.65, blue: 0.10, opacity: 1.0))
                
            Text(text1)
            .font(KarlaTiny)
            .padding()
                .padding(.leading, 0)
        }
        
        
    }
    
    init(text: String){
        text1 = text
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

struct kBody: View {
    var text1: String;
    var body: some View {
        Text(text1)
            .font(KarlaBody)
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
            .font(KarlaButton).fontWeight(.bold)
            .padding(.bottom, 8)
            .padding(.top, 32)
    }
    
    init(text: String){
        text1 = text
    }
}

struct primaryCTAButton: View {
    var text1: String;
    var body: some View {
        Text(text1)
            .font(KarlaButton)
            .fontWeight(.semibold)
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

struct secondaryCTAButton: View {
    var text1: String;
    var body: some View {
        
        Text(text1)
            .font(KarlaBody)
            .fontWeight(.semibold)
            .foregroundColor(.black)
            .padding(.top)

        
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

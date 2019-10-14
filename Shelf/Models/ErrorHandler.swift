//
//  ErrorHandler.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/14/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import Foundation

class ErrorHandler: ObservableObject {
    
    @Published var errorDetected: Bool = false;
    @Published var errorMessageText: String = "";
    
    static let errorHandler = ErrorHandler();
    
    private init() {
        //singleton
    }
   
}

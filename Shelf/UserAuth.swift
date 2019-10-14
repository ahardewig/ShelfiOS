//
//  UserAuth.swift
//  Shelf
//
//  Created by Alex Hardewig on 10/13/19.
//  Copyright © 2019 CS407. All rights reserved.
//

import Foundation
import Combine

class UserAuth: ObservableObject {

  let didChange = PassthroughSubject<UserAuth,Never>()

  // required to conform to protocol 'ObservableObject'
  let willChange = PassthroughSubject<UserAuth,Never>()

    func login(username: String, password: String) {
    // login request... on success:
    //self.isLoggedin = loginUser(username: username, password: password)
        print(isLoggedin)
  }

  var isLoggedin = false {
    didSet {
      didChange.send(self)
    }

    // willSet {
    //       willChange.send(self)
    // }
  }
}

//
//  User.swift
//  FireStoreTesting
//
//  Created by Sam on 10/9/18.
//  Copyright © 2018 SamWayne. All rights reserved.
//

import UIKit

class User {
    var name: String
    var age: Int
    var profilePicAsString: String
    
    init(name: String, age: Int, profilePicAsString: String) {
        self.name = name
        self.age = age
        self.profilePicAsString = profilePicAsString
    }
}

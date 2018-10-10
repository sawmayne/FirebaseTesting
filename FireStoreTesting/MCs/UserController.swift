//
//  UserController.swift
//  FireStoreTesting
//
//  Created by Sam on 10/9/18.
//  Copyright © 2018 SamWayne. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class UserController {
    static let shared = UserController()
    static let db = Firestore.firestore()
    let userRef = db.collection("users")
    
    var currentUser: User?
    
    func signup(email: String, password: String, name: String, age: Int) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("there was an error creating user \(error.localizedDescription)")
                return
            } else {
                guard let user = authResult?.user else { return }
                let uuid = user.uid
                let values = ["name" : name,
                              "age" : age,
                              "email" : email] as [String : Any]
                self.userRef.document(uuid).setData(values)
            }
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("🎃There was an error creating the user  🎃\(error.localizedDescription)")
                return
            }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            // fetch user info with uid here
        }
    }
    
    func readUser(completion: @escaping (Error?) -> ()) {
        userRef.document((Auth.auth().currentUser?.uid)!).getDocument { (querySnapshot, error) in
            if let error = error {
                completion(error)
                print("there was an error finding user documents \(error.localizedDescription)")
            }
            
            guard let name = querySnapshot?.get("name") as? String else {return}
            guard let age = querySnapshot?.get("age") as? Int else {return}

            let user = User(name: name, age: age)
            self.currentUser = user
            completion(nil)
//            self.currentUser?.name = querySnapshot?.get("name") as! String
//            self.currentUser?.age = querySnapshot?.get("age") as! Int
        }
    }
} 

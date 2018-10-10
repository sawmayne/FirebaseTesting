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
import FirebaseStorage

class UserController {
    
    static let shared = UserController()
    static let db = Firestore.firestore()
    let userRef = db.collection("users")
    let storage = Storage.storage()
    
    var currentUser: User?
    
    func signup(email: String, password: String, name: String, age: Int, profilePic: UIImage, completion: @escaping (Bool)->Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("there was an error creating user \(error.localizedDescription)")
                completion(false) ; return
            }
            guard let user = authResult?.user else { print("Error Unwrapping"); return }
            let uuid = user.uid
            
            // Grab the photo, change it into data
            guard let photoAsData = profilePic.jpegData(compressionQuality: 1.0) else { return }
            
            // create references to storage, with child nodes for organization/easier data retrieval
            let storageRef = self.storage.reference()
            let imagesRef = storageRef.child("ProfileImages")
            let userImageRef = imagesRef.child(uuid)
            
            // this puts data into the storage
            // could instead use .putFile, which essentially does the same thing but for larger objects; have not found a use case for it with limited research
            userImageRef.putData(photoAsData, metadata: nil) { (metaData, error) in
                if let error = error {
                    print("👽Could not download data from the profile image \(error.localizedDescription)👽")
                    completion(false) ; return
                }
                
                userImageRef.downloadURL(completion: { (url, error) in
                    if let error = error {
                        print("there was an error getting the images url \(error.localizedDescription)")
                        completion(false) ; return
                    }
                    guard let url = url else { return }
                    
                    let values = ["name" : name,
                                  "age" : age,
                                  "imageAsString" : url,
                                  "email" : email] as [String : Any]
                    self.userRef.document(uuid).setData(values)
                })
                completion(true) ; return
                
                // with metaData you can get information on the data such as file size and file type; only using it here for the completion handler for downloading the URL of it.
                // still want to download the image in order to convert it into a string to set in the users values
                // Maybe for later, add an observer instead of doing the download within the completion block; looks more impressive but not v familiar
                // getData if you want users to have the data downloaded to their local device, and accessible offline.
                // easiest way to quickly download a file, but loads its entirety into memory; protect against memory issues using the required maxSize
            }
        }
    }
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("🎃There was an error creating the user  🎃\(error.localizedDescription)")
                return
            }
        }
    }
    
    func readUser(completion: @escaping (Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return}
        userRef.document(uid).getDocument { (querySnapshot, error) in
            if let error = error {
                completion(error)
                print("there was an error finding user documents \(error.localizedDescription)")
            }
            
            guard let name = querySnapshot?.get("name") as? String else {return}
            guard let age = querySnapshot?.get("age") as? Int else {return}
            guard let imageAsString = querySnapshot?.get("imageAsString") as? String else { return }
            
            let user = User(name: name, age: age, profilePicAsString: imageAsString)
            self.currentUser = user
            completion(nil)
        }
    }
}

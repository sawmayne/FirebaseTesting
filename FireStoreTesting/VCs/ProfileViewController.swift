//
//  ProfileViewController.swift
//  FireStoreTesting
//
//  Created by Sam on 10/9/18.
//  Copyright © 2018 SamWayne. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        read()
    }
    
    func read() {
        UserController.shared.readUser { (error) in
            if let _ = error{
                fatalError()
            }else {
                print("successfully read data")
                
                self.nameLabel.text = UserController.shared.currentUser?.name
                self.ageLabel.text = "\(UserController.shared.currentUser?.age)"
            }
        }
        
    }
}

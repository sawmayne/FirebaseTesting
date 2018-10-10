//
//  SignupViewController.swift
//  FireStoreTesting
//
//  Created by Sam on 10/9/18.
//  Copyright © 2018 SamWayne. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignupViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    
    var photo: UIImage?
    
    func setup(){
        guard let email = emailTF.text, !email.isEmpty else { return }
        guard let password = passwordTF.text, !password.isEmpty else { return }
        guard let age = Int(ageTF.text!) else { return }
        guard let name = nameTF.text, !name.isEmpty else { return }
        guard let photo = photo else { return }
        UserController.shared.signup(email: email, password: password, name: name, age: age, profilePic: photo) { (success) in
            if success == true {
                print("wooo")
            }
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserController.shared.readUser { (error) in
            if let error = error {
                print("error reading user data \(error.localizedDescription)")
            }
        }
        emailTF.placeholder = "Enter email address"
        passwordTF.placeholder = "Enter password"
        nameTF.placeholder = "Enter name"
        ageTF.placeholder = "Enter age"
    }
    
    //image picker
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoSelectVC"{
            guard let destinationVC = segue.destination as? PhotoSelectViewController else {return}
            destinationVC.delegate = self
        }
    }
}
extension SignupViewController: PhotoSelectViewControllerDelegate{
    func photoSelected(_ photo: UIImage) {
        self.photo = photo
        print("🤕image selected🤕")
    }
    
}

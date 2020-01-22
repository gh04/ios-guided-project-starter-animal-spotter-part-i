//
//  LoginViewController.swift
//  AnimalSpotter
//
//  Created by Ben Gohlke on 4/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var signInButton: UIButton!
    
    var apiController: APIController?
    var loginType = LoginType.signUp

    override func viewDidLoad() {
        super.viewDidLoad()
//styling button.
        signInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
            signInButton.tintColor = .white
            signInButton.layer.cornerRadius = 8.0
    }
    
    // MARK: - Action Handlers
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        // perform login or sign up operation based on loginType
        //make sure there is a controller first
        guard let apiController = apiController else { return }
        //step two - make sure it's not empty
        guard let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty else { return }
        //objects passed from line 41 and 43
        //create the and instance of user
        let user = User(username: username, password: password)
        
        if loginType == .signUp {
            //passing in user we created from line 47
            apiController.signUp(with: user) { error in
                //checking for errors
                //simplified errors right now.
            if let error = error {
                print("Error occurred during sign up: \(error)")
            } else {
                //show alert to user that it worked and its all UI related
                //going to the main queue
                //any UI changes need to happed in the main queue
                DispatchQueue.main.async {
                    //creating alertController
                    let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please sign in", preferredStyle: .alert)
                    //create action
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    //assigning action to alertController
                    alertController.addAction(alertAction)
                    //present to the user. present is a method available in ViewControllers.
                    //self because we are inside the scope of closures.
                    self.present(alertController, animated: true) {
                        self.loginType = .signIn
                        //changing UI to login mode to make it easier to the user.
                        self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                        //changing the title
                        //we are doing the UI for the user instead of letting the UI default to sign up mode after user signed up. We already know what they want!
                        self.signInButton.setTitle("Sign In", for: .normal)
                        
                        //if you want a delay in presentation of when to change username in the view you can make the completion in the handler in the alert action. 
                    }
                }
            }
        }
                
        } else {
                apiController.signIn(with: user) { error in
                    if let error = error {
                        print("Error occurred during sign in: \(error)")
                    } else {
                        //dismissing modal view in the main queue after successfully signing in.
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
                
            }
    }
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        // switch UI between login types. segment in storyboard
        //setting the button title and state in code
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
}

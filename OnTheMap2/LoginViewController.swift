//
//  LoginViewController.swift
//  OnTheMap2
//
//  Created by Dandre Ealy on 1/27/17.
//  Copyright © 2017 Dandre Ealy. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
   
    
    let loginSave = UserDefaults.standard
    let activity = UIActivityIndicatorView(activityIndicatorStyle:.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.passwordField.delegate = self
       self.emailField.delegate = self
       self.activity.layer.cornerRadius = 10
       self.activity.frame = activity.frame.insetBy(dx: -10, dy: -10)
       self.activity.center = self.view.center
       self.activity.tag = 1001
       self.view.addSubview(activity)
}
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func loginButtonTouched(_ sender: Any) {
        self.activity.startAnimating()
        
        guard emailField.text != "" && passwordField.text != "" else {
            self.activity.stopAnimating()
            alert("Fill in both email and password", "Try again", self)
            
            return
        }
        let email = emailField.text, password = passwordField.text

        
    UdacityClient.sharedInstance().authenticateWithEmail(email!, password!) { (sucess, errorString, userID) in
            performUIUpdatesOnMain {
                if sucess {
                    self.activity.stopAnimating()
                    self.performSegue(withIdentifier: "loginToMain", sender: self)
                    self.loginSave.set(true, forKey: "loggedIn")
                    
                } else {
                    self.activity.stopAnimating()
                    alert("Please check your email or password again", "Try again", self)
                }

            }
        }
        
    }
    
    @IBAction func signupButtonTouched(_ sender: Any) {
        let url = URL(string: "https://www.udacity.com")
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
    }
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
        }
    }

}

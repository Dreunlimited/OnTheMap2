//
//  LoginViewController.swift
//  OnTheMap2
//
//  Created by Dandre Ealy on 1/27/17.
//  Copyright © 2017 Dandre Ealy. All rights reserved.
//

import UIKit
import SafariServices
import ReachabilitySwift

class LoginViewController: UIViewController, UITextFieldDelegate {

    let reachability = Reachability()!
    
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
        
//        reachability.whenUnreachable = { reachability in
//        
//            performUIUpdatesOnMain {
//                print("Not reachable")
//            }
//        }
//        
//        do {
//            try reachability.startNotifier()
//            print("yes")
//        } catch {
//            print("Unable to start notifier")
//        }
}
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        passwordField.text = ""
        emailField.text = ""
        
        subscribeToKeyboardNotifications()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()

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
    
    
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:  .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if passwordField.isFirstResponder {
            view.frame.origin.y = 0.0
        }
        
    }
    
    func keyboardWillShow(_ notification:Notification) {
        if passwordField.isFirstResponder {
            view.frame.origin.y = getKeyboardHeight( notification: notification as NSNotification ) * -1
        }
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        if passwordField.isFirstResponder {
            return keyboardSize.cgRectValue.height
        } else {
            return 0
        }
    }

    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
        }
    }

}

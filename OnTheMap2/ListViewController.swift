//
//  ListViewController.swift
//  OnTheMap2
//
//  Created by Dandre Ealy on 1/27/17.
//  Copyright © 2017 Dandre Ealy. All rights reserved.
//

import UIKit
import SafariServices


class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
     let loginSave = UserDefaults.standard
    
    
    var studentInforomation = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let appDel = UIApplication.shared.delegate as? AppDelegate
        
        studentInforomation = (appDel?.listLocation)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInforomation.count
    }
    
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListTableViewCell
        let fullName = studentInforomation[indexPath.row]
        
        cell?.nameLabel.text = ("\(fullName.firstName!) \(fullName.lastName!)")
        
        return cell!
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = studentInforomation[indexPath.row]
        if let url = URL(string: urlString.mediaURL!) {
            if url.scheme == nil {
                let newUrlString = "http://\(url)"
                let newURL = URL(string: newUrlString)
                let vc = SFSafariViewController(url: newURL!, entersReaderIfAvailable: true)
                present(vc, animated: true, completion: nil)
            } else {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                present(vc, animated: true, completion: nil)
                
            }
        }
        
        
    }

    @IBAction func logoutButtonTouched(_ sender: Any) {
        UdacityClient.sharedInstance().taskForDelete(Udacity.UDACITY.BASEURL) { (results, error) in
            performUIUpdatesOnMain {
                guard error == nil else {return}
                print("R \(results)")
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyBoard.instantiateViewController(withIdentifier: "login")
                self.present(loginVC, animated: true, completion: nil)
                self.loginSave.removeObject(forKey: "loggedIn")
            }
        }

    }
    @IBAction func addPinButtonTouched(_ sender: Any) {
    }

}

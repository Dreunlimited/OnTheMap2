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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentDataSource.sharedInstance.studentData.count
        
    }
    
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListTableViewCell
        let fullName = StudentDataSource.sharedInstance.studentData[indexPath.row]
        
        cell?.nameLabel.text = ("\(fullName.firstName!) \(fullName.lastName!)")
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = StudentDataSource.sharedInstance.studentData[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
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
                self.tabBarController?.dismiss(animated: true, completion: nil)
                self.loginSave.removeObject(forKey: "loggedIn")
                UdacityClient.sharedInstance().userKey.removeObject(forKey: "key")
            }
        }

    }

}

//
//  PinViewController.swift
//  OnTheMap2
//
//  Created by Dandre Ealy on 2/1/17.
//  Copyright © 2017 Dandre Ealy. All rights reserved.
//

import UIKit
import MapKit
import ReachabilitySwift

class PinViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var mediaURL: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapview: MKMapView!
    var lat:Double? = nil
    var long:Double? = nil
    let reachability = Reachability()!
    
    let activity = UIActivityIndicatorView(activityIndicatorStyle:.gray)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapview.delegate = self
        mapview.isHidden = true
        mapview.isPitchEnabled = true
        mapview.isZoomEnabled = true
        addressField.delegate = self
        postButton.isEnabled = false
        
        activity.layer.cornerRadius = 10
        activity.frame = activity.frame.insetBy(dx: -10, dy: -10)
        activity.center = self.view.center
        activity.tag = 1001
        view.addSubview(activity)
    }
    
    @IBAction func submitButton(_ sender: Any) {
        guard addressField.text != "" && mediaURL.text != "" else {
            alert("Please enter an address and link", "Try again", self)
            return
        }
        activity.startAnimating()
        alertLabel.text = ""
        
        let address = addressField.text
        let geo = CLGeocoder()
        
        geo.geocodeAddressString(address!) { (placemarks, error) in
            guard let placemarks = placemarks else {
                self.activity.stopAnimating()
                alert("Please enter your address again", "Try again", self)
                return }
            self.mapview.showsUserLocation = false
            let p = placemarks[0]
            let mp = MKPlacemark(placemark:p)
            self.mapview.removeAnnotations(self.mapview.annotations)
            self.mapview.addAnnotation(mp)
            self.mapview.setRegion(
                MKCoordinateRegionMakeWithDistance(mp.coordinate, 1000, 1000),
                animated: true)
            self.lat = mp.coordinate.latitude
            self.long = mp.coordinate.longitude
            self.mapview.isHidden = false
            self.addressField.isHidden = true
            self.mediaURL.isHidden = true
            self.submitButton.isHidden = true
            self.postButton.isEnabled = true
            self.activity.stopAnimating()
            
        }
    }
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true) {
            self.addressField.text = ""
            self.mediaURL.text = ""
            
        }
    }
    
    @IBAction func postButton(_ sender: Any) {
        performUIUpdatesOnMain {
            self.activity.startAnimating()
        }
        
        if reachability.currentReachabilityStatus == .notReachable {
            performUIUpdatesOnMain {
                self.activity.stopAnimating()
                alert("There was a lost in internet connection", "Try again", self)
            }
        } else {
            UdacityClient.sharedInstance().getUserProfile { (sucess, results, error) in
                
                
                if sucess {
                    
                    let first = results!["first_name"] as! String
                    let last = results!["last_name"] as! String
                    
                    ParseClient.sharedInstance().postStudentLocation("12", first, last, self.addressField.text!, self.mediaURL.text!, self.lat!, self.long!, completionHandlerForPostLocation: { (results, error) in
                        performUIUpdatesOnMain {
                            if error != nil {
                                alert(error!, "Try again", self)
                            } else {
                                self.activity.stopAnimating()
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    })
                    
                } else {
                    performUIUpdatesOnMain {
                        self.activity.stopAnimating()
                        alert(error!, "Try again", self)
                    }
                    
                }
                
            }
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}














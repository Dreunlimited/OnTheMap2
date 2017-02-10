//
//  PinViewController.swift
//  OnTheMap2
//
//  Created by Dandre Ealy on 2/1/17.
//  Copyright © 2017 Dandre Ealy. All rights reserved.
//

import UIKit
import MapKit

class PinViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var mediaURL: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapview: MKMapView!
    var lat:Double? = nil
    var long:Double? = nil
    
    let activity = UIActivityIndicatorView(activityIndicatorStyle:.gray)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapview.delegate = self
        mapview.isHidden = true
        mapview.isPitchEnabled = true
        mapview.isZoomEnabled = true
        addressField.delegate = self
        postButton.isEnabled = false
        
        self.activity.layer.cornerRadius = 10
        self.activity.frame = activity.frame.insetBy(dx: -10, dy: -10)
        self.activity.center = self.view.center
        self.activity.tag = 1001
        self.view.addSubview(activity)
        
}
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        self.activity.startAnimating()
        UdacityClient.sharedInstance().getUserProfile { (sucess, results, error) in
            if sucess == true {
                let first = results!["first_name"] as! String
                let last = results!["last_name"] as! String
            ParseClient.sharedInstance().postStudentLocation("12", first, last, self.addressField.text!, self.mediaURL.text!, self.lat!, self.long!, completionHandlerForPostLocation: { (results, error) in
            })
                if error != nil {
                    alert("There was error posting your pin", "Try again", self)
                } else {
                    self.activity.stopAnimating()
                    self.dismiss(animated: true, completion: nil)
                }
                
            } else {
                self.activity.stopAnimating()
                self.alertLabel.text = error
            }
        }
    }
}














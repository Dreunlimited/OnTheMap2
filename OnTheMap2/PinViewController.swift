//
//  PinViewController.swift
//  OnTheMap2
//
//  Created by Dandre Ealy on 2/1/17.
//  Copyright © 2017 Dandre Ealy. All rights reserved.
//

import UIKit
import MapKit

class PinViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var mediaURL: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapview: MKMapView!
    
    let activity = UIActivityIndicatorView(activityIndicatorStyle:.gray)


    override func viewDidLoad() {
        super.viewDidLoad()
        mapview.delegate = self
        mapview.isHidden = true
        mapview.isPitchEnabled = true
        mapview.isZoomEnabled = true
        
        postButton.isEnabled = false
        
        self.activity.layer.cornerRadius = 10
        self.activity.frame = activity.frame.insetBy(dx: -10, dy: -10)
        self.activity.center = self.view.center
        self.activity.tag = 1001
        self.view.addSubview(activity)
        
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func submitButton(_ sender: Any) {
        guard addressField.text != "" && mediaURL.text != "" else {
            alertLabel.text = "Please enter an address and link" ; return
        }
        activity.startAnimating()
        alertLabel.text = ""
        let address = addressField.text, url = mediaURL.text
        let geo = CLGeocoder()
        
        geo.geocodeAddressString(address!) { (placemarks, error) in
            guard let placemarks = placemarks else { self.alertLabel.text = "Error with coding your address" ; return }
            self.mapview.showsUserLocation = false
            let p = placemarks[0]
            let mp = MKPlacemark(placemark:p)
            self.mapview.removeAnnotations(self.mapview.annotations)
            self.mapview.addAnnotation(mp)
            self.mapview.setRegion(
                MKCoordinateRegionMakeWithDistance(mp.coordinate, 1000, 1000),
                animated: true)
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
    }
}

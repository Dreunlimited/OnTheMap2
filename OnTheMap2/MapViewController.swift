//
//  MapViewController.swift
//  OnTheMap2
//
//  Created by Dandre Ealy on 1/27/17.
//  Copyright © 2017 Dandre Ealy. All rights reserved.
//

import UIKit
import MapKit
import SafariServices


class MapViewController: UIViewController, MKMapViewDelegate{

  let loginSave = UserDefaults.standard
  
    @IBOutlet weak var mapview: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapview.delegate = self
        mapview.isHidden = true
        mapview.mapType = .standard
        mapview.isPitchEnabled = true
        mapview.isZoomEnabled = true
    
    }
    
    override func viewWillAppear(_ animated: Bool) {

        mapViewDidFinishLoadingMap(mapview)
        ParseClient.sharedInstance().getStudentLocation { (locations, error) in
            guard error == nil else {
                print(error!)
                return
            }
            var annotations = [MKPointAnnotation]()
            
            for location in locations! {
                let annotation = MKPointAnnotation()
               
                annotation.coordinate = location.location!
                annotation.title = "\(location.firstName!) \(location.lastName!)"
                annotation.subtitle = location.mediaURL
                annotations.append(annotation)
                self.mapview.addAnnotations(annotations)
            }
            
        }
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("tapped")
        if let mediaURL = view.annotation?.subtitle {
            
            if let url = URL(string: mediaURL!) {
                if url.scheme != nil {
                    let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                    present(vc, animated: true, completion: nil)
                } else {
                    let newUrlString = "http://\(url)"
                    let newURL = URL(string: newUrlString)
                    let vc = SFSafariViewController(url: newURL!, entersReaderIfAvailable: true)
                    present(vc, animated: true, completion: nil)
                }
                
            } else {
                
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "location") as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "location")
            
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.canShowCallout = true
        
        let btn = UIButton(type: .detailDisclosure)
        
        annotationView!.rightCalloutAccessoryView = btn
        
        return annotationView

    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        performUIUpdatesOnMain {
            self.mapview.isHidden = false
        }
    }
    
    @IBAction func logoutButtonTouched(_ sender: Any) {
        UdacityClient.sharedInstance().taskForDelete(Udacity.UDACITY.BASEURL) { (results, error) in
            performUIUpdatesOnMain {
                
                guard error == nil else { print("Error with logging out \(error)") ; return}
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyBoard.instantiateViewController(withIdentifier: "login")
                self.present(loginVC, animated: true, completion: nil)
                self.loginSave.removeObject(forKey: "loggedIn")
                UdacityClient.sharedInstance().userKey.removeObject(forKey: "key")
            }
        }
    }
    

}

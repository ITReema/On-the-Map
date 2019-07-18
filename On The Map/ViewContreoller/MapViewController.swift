//
//  MapViewController.swift
//  On The Map
//
//  Created by mac_os on 04/05/1440 AH.
//  Copyright © 1440 mac_os. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController:  UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var MapView: MKMapView!

    private var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUsers()
    }
    
    func getUsers(){
        annotations.removeAll()
        Parse.sharedInstance().getStudentLocations(){(locations, success, error)in
            DispatchQueue.main.async {
                if error != nil {
                    let alert = UIAlertController(title: "Erorr", message: "Failed Request", preferredStyle: .alert )
                    alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                var annotations = [MKPointAnnotation] ()
                guard let locationsArray = locations else {
                    
                    let alert = UIAlertController(title: "Erorr", message: "Erorr loading locations", preferredStyle: .alert )
                    alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }

                for location in locationsArray {
                    let longitude = CLLocationDegrees (location.longitude ?? 0)
                    let latitude = CLLocationDegrees (location.latitude ?? 0)
                    
                    let coordinates = CLLocationCoordinate2D (latitude: latitude, longitude: longitude)
                    let mediaURL = location.mediaURL ?? " "
                    let first = location.firstName ?? " "
                    let last = location.lastName ?? " "
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinates
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    annotations.append (annotation)
                }
                self.MapView.addAnnotations (annotations)
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        API.logout() { (success) in
            DispatchQueue.main.async {
                if success {
                    self.tabBarController?.dismiss(animated: true, completion: nil)
                    
                }else {
                    let alert = UIAlertController(title: "Erorr", message: "Error in Logout", preferredStyle: .alert )
                    alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return}
            }
        }
    }

    @IBAction func refreshButton(_ sender: Any) {
        getUsers()
        
    }
    
    @IBAction func addButton(_ sender: Any) {
        if let addLocationController = self.storyboard?.instantiateViewController(withIdentifier: "AddLocation") {
            self.present(addLocationController, animated: true, completion: nil)}
    }
    
}

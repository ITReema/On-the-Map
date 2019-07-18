//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by mac_os on 04/05/1440 AH.
//  Copyright © 1440 mac_os. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func findButton(_ sender: Any) {
        activityIndicator.isHidden = false
        guard let location = locationTextField.text, let url = urlTextField.text,
            location != "", url != "" else {
                let alert = UIAlertController(title: "Erorr", message: "Location and URL cannot be empty", preferredStyle: .alert )
                alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                    return
                }))
                self.present(alert, animated: true, completion: nil)
                return
        }
        let studentLocation = StudentLocation(mapString: location, mediaURL: url)
        findLocation(studentLocation)
    }
    
    func findLocation(_ search: StudentLocation){
        CLGeocoder().geocodeAddressString(search.mapString!) { (placemarks, error) in
            guard let firstLocation = placemarks?.first?.location else {
                let alert = UIAlertController(title: "Erorr", message: "Location not found ", preferredStyle: .alert )
                alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                    return
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            var location = search
            location.latitude = firstLocation.coordinate.latitude
            location.longitude = firstLocation.coordinate.longitude
            self.performSegue(withIdentifier: "toLocation", sender: location)
        }
    }

    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLocation", let vc = segue.destination as? FinalLocationViewController {
            vc.location = (sender as! StudentLocation)
        }
    }
}


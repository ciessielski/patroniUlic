//
//  ViewController.swift
//  patroniUlic
//
//  Created by Michal Ciesielski on 10.10.2016.
//  Copyright © 2016 Michal Ciesielski. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var streetNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("halko")
        
        streetNameLabel = UILabel.init(frame: CGRect(x: 0, y: 22, width: self.view.frame.width, height: 50))
        streetNameLabel.backgroundColor = .blue
        streetNameLabel.textColor = .white
        streetNameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        streetNameLabel.adjustsFontSizeToFitWidth = true
        streetNameLabel.textAlignment = .center
        streetNameLabel.text = "Belmonda"
        self.view.addSubview(streetNameLabel)
        
        let redStrip: UIView = UIView.init(frame: CGRect(x: 0, y: 72, width: self.view.frame.width, height: 12))
        redStrip.backgroundColor = .red
        self.view.addSubview(redStrip)
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func buildURLForGoogleSearch(name: String) -> String {
        return "https://www.google.pl/#q=\(name)"
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        location.streetNameWithCompletionBlock { street in
//            print(street!)
//            print(location)
            self.streetNameLabel.text = street!
            print(self.buildURLForGoogleSearch(name: street!))
        }
    }
}

typealias StreetNameHandler = (String?) -> Void

extension CLLocation {
    
    func streetNameWithCompletionBlock(completionBlock: @escaping StreetNameHandler) {
        
        CLGeocoder().reverseGeocodeLocation(self) { placemarks, error in
            
            if let addressDictionary = placemarks?.first?.addressDictionary, let street = addressDictionary["Thoroughfare"] as? String {
                completionBlock(street)
            }
        }
    }
}


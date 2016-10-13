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
    var webView: UIWebView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
        
        webView = UIWebView.init(frame: CGRect(x: 0, y: 84, width: self.view.frame.width, height: self.view.frame.height - 84))
        self.view.addSubview(webView)
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func loadWebViewContent(gUrl: String) {
        
        let gUrlClean = gUrl.replacingOccurrences(of: " ", with: "%20")
        let url = NSURL (string: gUrlClean)
        let requestObj = NSURLRequest(url: url as! URL);
        webView.loadRequest(requestObj as URLRequest)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        location.streetNameWithCompletionBlock { street in
            self.streetNameLabel.text = street!
            if (UserDefaults.standard.string(forKey: "previousStreet") != street!) {
                self.loadWebViewContent(gUrl: "https://www.google.pl/#q=\(street!)")
                UserDefaults.standard.setValue(street!, forKey: "previousStreet")
            }
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


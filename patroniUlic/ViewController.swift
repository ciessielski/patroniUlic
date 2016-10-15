//
//  ViewController.swift
//  patroniUlic
//
//  Created by Michal Ciesielski on 10.10.2016.
//  Copyright © 2016 Michal Ciesielski. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController {
    
    var locationManager: CLLocationManager!
    var streetNameLabel: UILabel!
    var webView: UIWebView!
    var refreshButton: UIButton!
    var displayStreet: String!
    var currentStreet: String!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        createStreetNameLabel()
        createrefreshButton()
        createRedStrip()
        createWebView()
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func createStreetNameLabel() {
        
        streetNameLabel = UILabel.init(frame: CGRect(x: 0, y: 22, width: self.view.frame.width, height: 50))
        streetNameLabel.backgroundColor = UIColor.warsawBlue()
        streetNameLabel.textColor = .white
        streetNameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        streetNameLabel.adjustsFontSizeToFitWidth = true
        streetNameLabel.textAlignment = .center
        streetNameLabel.text = "..."
        self.view.addSubview(streetNameLabel)
    }
    
    func createrefreshButton() {
        
        refreshButton = UIButton.init(frame: CGRect(x: self.view.frame.width - 60, y: 30, width: 30, height: 30))
        refreshButton.setImage(UIImage(named: "refresh_icon"), for: .normal)
        refreshButton.isHidden = true
        refreshButton.addTarget(self, action: #selector(ViewController.refreshPressed(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(refreshButton)
    }
    
    func createRedStrip() {
        let redStrip: UIView = UIView.init(frame: CGRect(x: 0, y: 72, width: self.view.frame.width, height: 12))
        redStrip.backgroundColor = UIColor.warsawRed()
        self.view.addSubview(redStrip)
    }
    
    func createWebView() {
        webView = UIWebView.init(frame: CGRect(x: 0, y: 84, width: self.view.frame.width, height: self.view.frame.height - 84))
        self.view.addSubview(webView)
    }
    
    func refreshPressed(_ sender: AnyObject) {
        print("refresh")
    }
    
    func showRefreshButton() {
        refreshButton.isHidden = false
    }
    
    func hideRefreshButton() {
        refreshButton.isHidden = true
    }
    
    func loadWebViewContent(gUrl: String) {
        
        let gUrlClean = gUrl.replacingOccurrences(of: " ", with: "%20")
        let url = NSURL (string: gUrlClean)
        let requestObj = NSURLRequest(url: url as! URL);
        webView.loadRequest(requestObj as URLRequest)
    }
}

//MARK: LocationManager
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        location.streetNameWithCompletionBlock { street in
            self.streetNameLabel.text = street!
            print("street: \(street!)")
            
            if (self.previousStreet != self.currentStreet) {
//                self.loadWebViewContent(gUrl: "https://www.google.pl/#q=\(street!)")
//                if (self.previousStreet != nil) {
//                    self.showRefreshButton()
                self.showRefreshButton()
                self.previousStreet = street!
            }
        else {
                //                self.hideRefreshButton()
            }
        }
    }
}

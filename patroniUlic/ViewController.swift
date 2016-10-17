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
        
        print("view did load")
        
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
        
        let statusBarBCG = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 22))
        statusBarBCG.backgroundColor = UIColor.warsawBlue()
        self.view.addSubview(statusBarBCG)
        
        let labelBCG = UIView.init(frame: CGRect(x: 0, y: 22, width: self.view.frame.width, height: 50))
        labelBCG.backgroundColor = UIColor.warsawBlue()
        self.view.addSubview(labelBCG)
        
        streetNameLabel = UILabel.init(frame: CGRect(x: 0, y: 22, width: self.view.frame.width, height: 50))
        streetNameLabel.textColor = .white
        streetNameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        streetNameLabel.adjustsFontSizeToFitWidth = true
        streetNameLabel.textAlignment = .center
        streetNameLabel.text = "..."
        self.view.addSubview(streetNameLabel)
    }
    
    func createrefreshButton() {
        
        refreshButton = UIButton.init(frame: CGRect(x: self.view.frame.width - 35, y: 32, width: 30, height: 30))
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
        webView.backgroundColor = UIColor.warsawRed()   
        self.view.addSubview(webView)
    }
    
    func refreshPressed(_ sender: AnyObject) {
        
        self.streetNameLabel.text = self.currentStreet!
        self.loadWebViewContent(gUrl: self.currentStreet!)
        self.displayStreet = self.currentStreet!
        
        self.hideRefreshButton()
    }
    
    func showRefreshButton() {
        refreshButton.isHidden = false
        
        streetNameLabel.frame = CGRect(x: 0, y: 22, width: self.view.frame.width - 40, height: 50)
    }
    
    func hideRefreshButton() {
        
        streetNameLabel.frame = CGRect(x: 0, y: 22, width: self.view.frame.width, height: 50)
        refreshButton.isHidden = true
    }
    
    func loadWebViewContent(gUrl: String) {
        
        var gUrlClean = gUrl.replacingOccurrences(of: " ", with: "%20")
        gUrlClean = "https://www.google.pl/#q=" + gUrlClean
        let url = NSURL (string: gUrlClean)
        print("load web view url: \(url)")
        let requestObj = NSURLRequest(url: url as! URL);
        webView.loadRequest(requestObj as URLRequest)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


//MARK: LocationManager
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        location.streetNameWithCompletionBlock { street in
            
            if (self.currentStreet == nil && self.displayStreet == nil) {
                self.currentStreet = street!
                self.displayStreet = self.currentStreet
                self.streetNameLabel.text = self.displayStreet!
                self.loadWebViewContent(gUrl: self.displayStreet!)
            } else if (self.displayStreet != self.currentStreet) {
                self.showRefreshButton()
            }
            
            self.currentStreet = street!
        }
    }
}

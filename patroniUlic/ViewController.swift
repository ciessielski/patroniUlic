//
//  ViewController.swift
//  patroniUlic
//
//  Created by Michal Ciesielski on 10.10.2016.
//  Copyright © 2016 Michal Ciesielski. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMobileAds


class ViewController: UIViewController {
    
    var locationManager: CLLocationManager!
    var streetNameLabel: UILabel!
    var webView: UIWebView!
    var adView: GADBannerView!
    var refreshButton: UIButton!
    var displayStreet: String!
    var currentStreet: String!
    
    var testNames: [String] = ["Adama Mickiewicza", "Elizy Orzeszkowej", "Andrzeja Wajdy", "Jana Pawła II", "Maurycego Mochnackiego", "Gabrieli Zapolskiej", "Franciszka Bohomolca", "Stanisława Tołpy", "Stefana Jaracza", "Józefa Supińskiego"]

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        for name in testNames {
            print(nominativusFrom(genetivus: name))
        }
        
        createStreetNameLabel()
        createrefreshButton()
        createRedStripe()
        createWebView()
        createAdView()
        
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
    
    func createRedStripe() {
        
        let redStrip: UIView = UIView.init(frame: CGRect(x: 0, y: 72, width: self.view.frame.width, height: 12))
        redStrip.backgroundColor = UIColor.warsawRed()
        self.view.addSubview(redStrip)
    }
    
    func createWebView() {
        
        webView = UIWebView.init(frame: CGRect(x: 0, y: 84, width: self.view.frame.width, height: self.view.frame.height - (84+50)))
        webView.backgroundColor = UIColor.warsawRed()   
        self.view.addSubview(webView)
    }
    
    func createAdView() {
        
        adView = GADBannerView.init(frame: CGRect(x: 0, y: self.view.frame.height - 50, width: self.view.frame.width, height: 50))
        adView.adUnitID = "ca-app-pub-2539884439806042/6259053812"
        adView.rootViewController = self
        let request = GADRequest()
        request.testDevices = ["a924d7c1f311f8564b0f10af98a4829caa9923ea", "kGADSimulatorID"]
        adView.load(request)
        self.view.addSubview(adView)
    }
    
    func refreshPressed(_ sender: AnyObject) {
        
        self.streetNameLabel.text = self.currentStreet!
        self.loadWebViewContent(search: self.currentStreet!)
        self.displayStreet = self.currentStreet!
        
        self.hideRefreshButton()
    }
    
    func showRefreshButton() {
        
        UIView.animate(withDuration: 1, animations: {
            self.refreshButton.isHidden = false
            self.refreshButton.alpha = 1
        })
    }
    
    func hideRefreshButton() {
        
        UIView.animate(withDuration: 1, animations: {
            self.refreshButton.alpha = 0
            self.refreshButton.isHidden = true
        })
    }
    
    func loadWebViewContent(search: String) {
        
        let wikiSearch = "http://pl.wikipedia.org/wiki/" + nominativusFrom(genetivus: search)
        var url = NSURL (string: wikiSearch)
        
        if (wikiSearch == "http://pl.wikipedia.org/wiki/") {
            var gSearch = search.replacingOccurrences(of: " ", with: "%20")
            gSearch = "https://www.google.pl/#q=" + gSearch
            url = NSURL (string: gSearch)
        }
        
        if (url != nil) {
            let requestObj = NSURLRequest(url: url as! URL)
            webView.loadRequest(requestObj as URLRequest)
        }
    }
    
    func nominativusFrom(genetivus: String) -> String {
        
        if (genetivus.contains(" ")) {
            
            let nom = genetivus.replacingOccurrences(of: " ", with: "_") as NSString
        
            var name = nom.substring(to: nom.range(of: "_").location) as NSString
            var surname = nom.substring(from: nom.range(of: "_").location + 1) as NSString
            
            if (name.hasSuffix("wła")) {
                name = name.replacingOccurrences(of: "wła", with: "weł") as NSString
            }
            
            if (name.hasSuffix("ka")) {
                name = name.replacingOccurrences(of: "ka", with: "ek") as NSString
            }
            
            if (name.hasSuffix("a")) {
                
                name = name.substring(to: name.length - 1) as NSString
            }
            
            if (name.hasSuffix("y") || name.hasSuffix("i") ) {
                name = name.substring(to: name.length - 1).appending("a") as NSString
            }
            
            if (name.hasSuffix("ego")) {
                
                name = name.replacingOccurrences(of: "iego", with: "") as NSString
                name = name.replacingOccurrences(of: "ego", with: "y") as NSString
            }
            
            if (surname.hasSuffix("ego")) {
                
                surname = surname.replacingOccurrences(of: "iego", with: "i") as NSString
                surname = surname.replacingOccurrences(of: "ego", with: "y") as NSString
            }
            
            if (surname.hasPrefix("Pawła")) {
                surname = surname.replacingOccurrences(of: "Pawła", with: "Paweł") as NSString
            }
            
            if (surname.hasSuffix("ca")) {
                surname = surname.replacingOccurrences(of: "ca", with: "ec") as NSString
            }
            
            if (surname.hasSuffix("a")) {
                surname = surname.substring(to: surname.length - 1) as NSString
            } else if (surname.hasSuffix("y")) {
                surname = surname.substring(to: surname.length - 1).appending("a") as NSString
            }
            
            if (surname.hasSuffix("iej")) {
                surname = surname.replacingOccurrences(of: "iej", with: "a") as NSString
            }
            
            if (surname.hasSuffix("ej")) {
                surname = surname.replacingOccurrences(of: "ej", with: "a") as NSString
            }
            
            return (name as String) + "_" + (surname as String)
        } else { return ""}
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
            
//            print("loc: \(street!)")
            
            if (self.currentStreet == nil && self.displayStreet == nil) {
                self.currentStreet = street!
                self.displayStreet = self.currentStreet
                self.streetNameLabel.text = self.displayStreet!
                self.loadWebViewContent(search: self.displayStreet!)
            } else if (self.displayStreet != self.currentStreet) {
                self.showRefreshButton()
            } else {
                self.hideRefreshButton()
            }
            
            self.currentStreet = street!
        }
    }
}

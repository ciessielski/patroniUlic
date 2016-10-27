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


class MainViewController: UIViewController, UIWebViewDelegate {
    
    var locationManager: CLLocationManager!
    var streetNameLabel: UILabel!
    var webView: UIWebView!
    var adView: GADBannerView!
    var refreshButton: UIButton!
    var displayStreet: String!
    var currentStreet: String!
    var refreshButtonDisplayed: Bool = false
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
    
//        self.test() //uncomment for testing new street names
        
        createStreetNameLabel()
        createWebView()
        createRedStripe()
        createAdView()
        createRefreshButton()
        
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
        
        let labelBCG = UIView.init(frame: CGRect(x: 0 , y: 22, width: self.view.frame.width, height: 50))
        labelBCG.backgroundColor = UIColor.warsawBlue()
        self.view.addSubview(labelBCG)
        
        streetNameLabel = UILabel.init(frame: CGRect(x: 10, y: 22, width: self.view.frame.width - 20, height: 50))
        streetNameLabel.textColor = .white
        streetNameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        streetNameLabel.adjustsFontSizeToFitWidth = true
        streetNameLabel.textAlignment = .center
        streetNameLabel.text = "..."
        self.view.addSubview(streetNameLabel)
    }
    
    func createRefreshButton() {
        
        refreshButton = UIButton.init(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 50))
        refreshButton.backgroundColor = UIColor.warsawRed()
        refreshButton.setImage(UIImage(named: "refresh_icon"), for: .normal)
        refreshButton.addTarget(self, action: #selector(MainViewController.refreshPressed(_:)), for: UIControlEvents.touchUpInside)
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
        
        refreshButtonDisplayed = true
        UIView.animate(withDuration: 1, animations: {
            
            self.adView.center.y += 50
            self.refreshButton.center.y -= 50
        })
    }
    
    func hideRefreshButton() {
        
        refreshButtonDisplayed = false
        UIView.animate(withDuration: 1, animations: {
                self.adView.center.y -= 50
                self.refreshButton.center.y += 50
        })
    }
    
    func loadWebViewContent(search: String) {
        
        let wikiSearch = "http://pl.wikipedia.org/wiki/" + String().nominativusFrom(genetivus: search)
        var url = NSURL (string: wikiSearch)
        
        if (wikiSearch == "http://pl.wikipedia.org/wiki/") {
            var gSearch = search.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            gSearch = "https://www.google.pl/#q=" + gSearch
            url = NSURL (string: gSearch)
        }
                
        if (url != nil) {
            let requestObj = NSURLRequest(url: url as! URL)
            webView.loadRequest(requestObj as URLRequest)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func test() {
        
        let testNames = ["Adama Mickiewicza", "Elizy Orzeszkowej", "Andrzeja Wajdy", "Jana Pawła II", "Maurycego Mochnackiego", "Gabrieli Zapolskiej", "Franciszka Bohomolca", "Stanisława Tołpy", "Stefana Jaracza", "Józefa Supińskiego", "Marii Curie-Skłodowskiej", "Marii Skołodowskiej-Curie", "Jana Matejki", "Plac Zbawiciela", "św. Mikołaja", "św. Maksymiliana Kolbego", "Plac Konstytucji", "Aleja Karkonowska", "Antoniego Józefa Madalińskiego"]
        
        for name in testNames {
            print(String().nominativusFrom(genetivus: name))
        }
    }
}


//MARK: LocationManager
extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        location.streetNameWithCompletionBlock { street in
            
//            print(street!) //uncomment for testing location
            if (self.currentStreet == nil && self.displayStreet == nil) {
                self.currentStreet = street!
                self.displayStreet = self.currentStreet
                self.streetNameLabel.text = self.displayStreet!
                self.loadWebViewContent(search: self.displayStreet!)
            } else if (self.currentStreet != self.displayStreet && !self.refreshButtonDisplayed) {
                self.showRefreshButton()
            } else if (self.currentStreet == self.displayStreet && self.refreshButtonDisplayed) {
                self.hideRefreshButton()
            }
            
            self.currentStreet = street!
        }
    }
}

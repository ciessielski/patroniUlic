//
//  Extensions.swift
//  patroniUlic
//
//  Created by Michal Ciesielski on 15.10.2016.
//  Copyright © 2016 Michal Ciesielski. All rights reserved.
//

import UIKit
import CoreLocation


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

extension UIColor {
    
    convenience init(hex: String) {
                
        var cString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = String(cString.characters.dropFirst())
        }
        
        if ((cString.characters.count) != 6) {
            print("wrong hex format")
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        let components = (
            R: CGFloat((rgbValue >> 16) & 0xff) / 255,
            G: CGFloat((rgbValue >> 08) & 0xff) / 255,
            B: CGFloat((rgbValue >> 00) & 0xff) / 255
        )
        
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    class func warsawBlue() -> UIColor {
        return UIColor(hex: "0170e6")
    }
    
    class func warsawRed() -> UIColor {
        return UIColor(hex: "fc393b")
    }
}


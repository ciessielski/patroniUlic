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

extension String {
    
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
            
            if (name.hasSuffix("ra")) {
                name = name.replacingOccurrences(of: "ra", with: "er") as NSString
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
            
            if (surname.hasSuffix("jki")) {
                surname = surname.replacingOccurrences(of: "jki", with: "jko") as NSString
            }
            
            if (surname.hasSuffix("a")) {
                surname = surname.substring(to: surname.length - 1) as NSString
            } else if (surname.hasSuffix("y")) {
                surname = surname.substring(to: surname.length - 1).appending("a") as NSString
            }
            
            if (surname.contains("wskiej")) {
                surname = surname.replacingOccurrences(of: "wskiej", with: "wska") as NSString
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
}


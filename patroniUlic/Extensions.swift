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
        
        var nom = genetivus.replacingOccurrences(of: " ", with: "_") as NSString
        
        if (nom.hasPrefix("Plac_")) {
            nom = nom.replacingOccurrences(of: "Plac_", with: "") as NSString
        }
        
        if (nom.hasPrefix("Aleja_")) {
            nom = nom.replacingOccurrences(of: "Aleja_", with: "") as NSString
        }
        
        if (nom.hasPrefix("św._")) {
            nom = nom.replacingOccurrences(of: "św._", with: "") as NSString
        }
        
        if (nom.hasPrefix("gen._")) {
            nom = nom.replacingOccurrences(of: "gen._", with: "") as NSString
        }
        
        if (nom.hasPrefix("płk._")) {
            nom = nom.replacingOccurrences(of: "płk._", with: "") as NSString
        }

        if (nom.contains("_")) {
            
            var components = nom.components(separatedBy: "_")
            var name: NSString = components[0] as NSString
            var middlename: NSString = ""
            var surname: NSString = ""
            
            if (components.count == 3) {
                middlename = components[1] as NSString
                surname = components[2] as NSString
            } else if (components.count == 2) {
                surname = components[1] as NSString
            } else {
                print("WHAT A NAME!?")
            }
            
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
                name = name.replacingOccurrences(of: "olbego", with: "olbe") as NSString
                name = name.replacingOccurrences(of: "iego", with: "i") as NSString
                name = name.replacingOccurrences(of: "ego", with: "y") as NSString
            }
            
            if (middlename.hasSuffix("wła")) {
                middlename = middlename.replacingOccurrences(of: "wła", with: "weł") as NSString
            }
            
            if (middlename.hasSuffix("ka")) {
                middlename = middlename.replacingOccurrences(of: "ka", with: "ek") as NSString
            }
            
            if (middlename.hasSuffix("ra")) {
                middlename = middlename.replacingOccurrences(of: "ra", with: "er") as NSString
            }
            
            if (middlename.hasSuffix("a")) {
                middlename = middlename.substring(to: middlename.length - 1) as NSString
            }
            
            if (middlename.hasSuffix("y") || middlename.hasSuffix("i") ) {
                middlename = middlename.substring(to: middlename.length - 1).appending("a") as NSString
            }
            
            if (middlename.hasSuffix("ego")) {
                middlename = middlename.replacingOccurrences(of: "olbego", with: "olbe") as NSString
                middlename = middlename.replacingOccurrences(of: "iego", with: "i") as NSString
                middlename = middlename.replacingOccurrences(of: "ego", with: "y") as NSString
            }
            
            if (surname.hasSuffix("olbego")) {
                surname = surname.replacingOccurrences(of: "olbego", with: "olbe") as NSString
            }
            
            if (surname.hasSuffix("ego")) {
                surname = surname.replacingOccurrences(of: "iego", with: "i") as NSString
                surname = surname.replacingOccurrences(of: "ego", with: "y") as NSString
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
            
            var output = (name as String) + "_" + (middlename as String) + "_" + (surname as String)
            
            if (output == "Antoni_Józef_Madaliński" ) {
                output = "Antoni_Madaliński"
            }
            
            return output
        } else { return ""}
    }
}


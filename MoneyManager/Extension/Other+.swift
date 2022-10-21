//
//  Other+.swift
//  MoneyManager
//
//  Created by Nam Ngây on 20/12/2021.
//

import Foundation
import UIKit
import LocalAuthentication

extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8_SE2 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS_11_11Pro = "iPhone X or iPhone XS"
        case iPhone_XR = "iPhone XR"
        case iPhone_XSMax_11ProMax = "iPhone XS Max or iPhone 11 Pro Max"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhones_4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8_SE2
        case 1792:
            return .iPhone_XR
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhones_X_XS_11_11Pro
        case 2688:
            return .iPhone_XSMax_11ProMax
        default:
            return .unknown
        }
    }
}

extension UIColor {
    @nonobjc class var disabledGrey: UIColor {
        
        return UIColor(red: 194/255, green: 198/255, blue: 201/255, alpha:1.0)
    }

    @nonobjc class var darkblue: UIColor {
        return UIColor(red: 2.0 / 255.0, green: 21.0 / 255.0, blue: 101.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var primary: UIColor {
        return UIColor(hex: "#00B14F")!
        //UIColor(red: 0 / 255.0, green: 20.0 / 255.0, blue: 35.0 / 255.0, alpha: 1.0)
    }
    
    public convenience init?(hex: String, alpha: CGFloat = 1) {
        let r, g, b: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: alpha)
                    return
                }
            }
        } else {
          let hexColor = hex
          if hexColor.count == 6 {
              let scanner = Scanner(string: hexColor)
              var hexNumber: UInt64 = 0

              if scanner.scanHexInt64(&hexNumber) {
                  r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                  g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                  b = CGFloat(hexNumber & 0x0000ff) / 255

                  self.init(red: r, green: g, blue: b, alpha: alpha)
                  return
              }
          }
        }

        return nil
    }
}

extension NSObject {
    
    var className: String {
        return String(describing: type(of: self)).components(separatedBy: ".").last!
    }
    
    class var className: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}
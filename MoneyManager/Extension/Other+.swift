//
//  Other+.swift
//  MoneyManager
//
//  Created by Nam Ngây on 20/12/2021.
//

import Foundation
import UIKit
import LocalAuthentication

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
    
    static func random() -> UIColor {
        return UIColor(
            red:   .random(),
            green: .random(),
            blue:  .random(),
            alpha: 0.5
        )
    }
    
    func components() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        guard let c = cgColor.components else { return (0, 0, 0, 1) }
        if cgColor.numberOfComponents == 2 {
            return (c[0], c[0], c[0], c[1])
        } else {
            return (c[0], c[1], c[2], c[3])
        }
    }

    
    static func interpolate(from: UIColor, to: UIColor, with fraction: CGFloat) -> UIColor {
        let f = min(1, max(0, fraction))
        let c1 = from.components()
        let c2 = to.components()
        let r = c1.0 + (c2.0 - c1.0) * f
        let g = c1.1 + (c2.1 - c1.1) * f
        let b = c1.2 + (c2.2 - c1.2) * f
        let a = c1.3 + (c2.3 - c1.3) * f
        return UIColor(red: r, green: g, blue: b, alpha: a)
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

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter
    }()
}

extension Numeric {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}

extension UIPageViewController {

    public var scrollView: UIScrollView? {
        for view in self.view.subviews {
            if let scrollView = view as? UIScrollView {
                return scrollView
            }
        }
        return nil
    }

}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

func parseCategory(_ text: String) -> String {
    switch text {
    case "car":
        return "Xe cộ"
    case "device":
        return "Máy móc"
    case "health":
        return "Sức khoẻ"
    case "house":
        return "Nhà cửa"
    case "office":
        return "Công việc"
    case "food":
        return "Ăn uống"
    case "shopping":
        return "Mua sắm"
    case "other":
        return "Khác"
    default:
        break
    }
    return ""
}

struct DateFormatters {
    static var shortDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()

    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()

    static var weekdayFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter
    }()
}

//
//  String+.swift
//  MoneyManager
//
//  Created by Nam Ngây on 07/07/2021.
//

import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    subscript(idx: Int) -> String {
        String(self[index(startIndex, offsetBy: idx)])
    }
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    func isValidPhone() -> Bool {
        let phonenumberRegex = "^(\(Session.shared.validPhone))+([0-9]{7})$"
        print("Phone regex: \(phonenumberRegex)")
        let phonenumber = NSPredicate(format:"SELF MATCHES %@", phonenumberRegex)
        var value = phonenumber.evaluate(with: self)
        if !value {
            let phonenumberRegex = "^(\(Session.shared.validPhone.replacingOccurrences(of: "0", with: "")))+([0-9]{6})$"
            print("Phone regex: \(phonenumberRegex)")
            let phonenumber = NSPredicate(format:"SELF MATCHES %@", phonenumberRegex)
            value = phonenumber.evaluate(with: self)
        }
        return value
    }
    
}

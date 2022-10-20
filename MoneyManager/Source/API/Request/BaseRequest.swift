//
//  BaseRequest.swift
//  MoneyManager
//
//  Created by Nam Ngây on 24/01/2022.
//

import Foundation
import Alamofire

class BaseRequest: NSObject {
    
    var url = ""
    var requestType = Alamofire.HTTPMethod.get
    var query: [URLQueryItem] = []
    var body: [String: Any]?
    
    var encoding: ParameterEncoding {
        switch requestType {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    init(url: String) {
        super.init()
        self.url = url
    }
    
    init(url: String, requestType: Alamofire.HTTPMethod) {
        super.init()
        self.url = url
        self.requestType = requestType
    }
    
    init(url: String, requestType: Alamofire.HTTPMethod, body: [String: Any]?) {
        super.init()
        self.url = url
        self.requestType = requestType
        self.body = body
    }
    
    init(url: String, requestType: Alamofire.HTTPMethod, query: [URLQueryItem]) {
        super.init()
        self.url = url
        self.requestType = requestType
        self.query = query
    }
}

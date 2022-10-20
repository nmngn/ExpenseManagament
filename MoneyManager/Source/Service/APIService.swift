//
//  APIService.swift
//  MoneyManager
//
//  Created by Nam Ngây on 24/01/2022.
//

import Foundation
import Alamofire
import ObjectMapper
import Then

struct ApiService {
    
    static let share = ApiService()
    
    private var alamofireManager = Alamofire.SessionManager.default
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.do {
            $0.timeoutIntervalForRequest = 30
            $0.timeoutIntervalForResource = 30
        }
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func request<T: Mappable>(input: BaseRequest, completion: @escaping (_ value: T?, _ error: BaseError?) -> Void) {
        alamofireManager.request(input.url, method: input.requestType, parameters: input.body, encoding: input.encoding)
            .validate(statusCode: 200..<500)
            .responseJSON { response in
                print("\(String(describing: response.request?.httpMethod)) - \(String(describing: response.request?.url?.absoluteString))")
                switch response.result {
                case .success(let value):
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 200 {
                            let object = Mapper<T>().map(JSONObject: value)
                            print("Response: \(object)")
                            completion(object, nil)
                        } else {
                            if let error = Mapper<ErrorResponse>().map(JSONObject: value) {
                                completion(nil, BaseError.apiFailure(error: error))
                            } else {
                                completion(nil, BaseError.httpError(httpCode: statusCode))
                            }
                        }
                    } else {
                        completion(nil, BaseError.unexpectedError)
                    }
                case .failure(let error):
                    completion(nil, error as? BaseError)
            }
        }
    }
    
}

//
//  BaseError.swift
//  MoneyManager
//
//  Created by Nam Ngây on 24/01/2022.
//

import Foundation

enum BaseError: Error {
    case networkError
    case httpError(httpCode: Int)
    case unexpectedError
    case apiFailure(error: ErrorResponse?)
    
    public var errorMessage: String? {
        switch self {
        case .networkError:
            return "Network Error"
        case .httpError(let code):
            return getHttpErrorMessage(httpCode: code)
        case .apiFailure(let error):
            if let error = error {
                return error.message
            }
            return "Error"
        default:
            return "Unexpected Error"
        }
    }
    
    private func getHttpErrorMessage(httpCode: Int) -> String? {
        if httpCode >= 300 && httpCode <= 308 {
            // Redirection
            return "It was transferred to a different URL. I'm sorry for causing you trouble"
        } else if httpCode >= 400 && httpCode <= 451 {
            // Client error
            return "An error occurred on the application side. Please try again later!"
        } else if httpCode >= 500 && httpCode <= 511 {
            // Server error
            return "A server error occurred. Please try again later!"
        } else {
            // Unofficial error
            return "An error occurred. Please try again later!"
        }
    }
}

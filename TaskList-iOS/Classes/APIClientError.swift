//
//  APIClientError.swift
//  TaskList-iOS
//
//  Created by KAKEGAWA Atsushi on 2016/07/04.
//  Copyright © 2016年 KAKEGAWA Atsushi. All rights reserved.
//

import Foundation

enum APIClientError: ErrorType {
    case RequestFailed(e: ErrorType)
    case InvalidResponse(e: ErrorType, body: AnyObject)
    case ErrorResponse(statusCode: Int, message: String?)
}

extension APIClientError {
    
    func translateToApplicationError() -> ApplicationError {
        switch self {
        case .RequestFailed(let e as NSError) where e.code == NSURLErrorNotConnectedToInternet:
            return ApplicationError(message: "Requested operation failed. Please try again later.")
        case .RequestFailed:
            return ApplicationError(message: "Unexpected error has occured.")
        case .InvalidResponse:
            return ApplicationError(message: "Unexpected error has occured.")
        case .ErrorResponse(statusCode: 400, message: let message):
            return ApplicationError(message: message ?? "Failed to operation. It seems that there is some invalid data in your request.")
        case .ErrorResponse(let statusCode, message: _) where statusCode >= 500:
            return ApplicationError(message: "Requested operation failed. Please try again later.")
        case .ErrorResponse:
            return ApplicationError(message: "Unexpected error has occured.")
        }
    }
    
}

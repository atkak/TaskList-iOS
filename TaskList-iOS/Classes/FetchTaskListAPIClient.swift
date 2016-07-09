//
//  FetchTaskListAPIClient.swift
//  TaskList-iOS
//
//  Created by KAKEGAWA Atsushi on 2016/06/25.
//  Copyright © 2016年 KAKEGAWA Atsushi. All rights reserved.
//

import Foundation
import BrightFutures
import Alamofire
import Himotoki

class FetchTaskListAPIClient {
    
    func findAll() -> Future<[Task], APIClientError> {
        let baseURL = AppConfiguration.webAPIBaseURL
        let promise = Promise<[Task], APIClientError>()
        
        Alamofire.request(.GET, "\(baseURL)/tasks")
            .responseJSON { response in
                switch response.result {
                case .Success(let jsonObj):
                    if let statusCode = response.response?.statusCode where statusCode >= 300 {
                        let errorMessage = (jsonObj as? [String: String])?["errorMessage"]
                        promise.failure(.ErrorResponse(statusCode: statusCode, message: errorMessage))
                        return
                    }
                    
                    do {
                        let tasks = try self.decode(jsonObj)
                        promise.success(tasks)
                    } catch let e {
                        promise.failure(.InvalidResponse(e: e, body: jsonObj))
                    }
                case .Failure(let error):
                    promise.failure(.RequestFailed(e: error))
                }
            }
        
        return promise.future
    }
    
    private func decode(json: AnyObject) throws -> [Task] {
        return try decodeArray(json)
    }
    
}

extension Task: Decodable {
    
    static func decode(e: Extractor) throws -> Task {
        let DateTransformer = Transformer<String, NSDate> { dateString throws -> NSDate in
            if let date = DateFormatter.dueDateFormatter.dateFromString(dateString) {
                return date
            }
            
            throw TaskDecodeError.DateFormat
        }
        
        return try Task(
            id: e <| "id",
            title: e <| "title",
            description: e <|? "description",
            dueDate: try DateTransformer.apply(e <| "dueDate")
        )
    }
    
}

enum TaskDecodeError: ErrorType {
    case DateFormat
}

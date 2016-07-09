import Foundation
import BrightFutures
import Alamofire
import Himotoki

class CreateTaskAPIClient {
    
    func create(task: CreateTask) -> Future<String, APIClientError> {
        let baseURL = AppConfiguration.webAPIBaseURL
        let promise = Promise<String, APIClientError>()
        
        let dueDateString = DateFormatter.dueDateFormatter.stringFromDate(task.dueDate)
        var params: [String: AnyObject] = ["title": task.title, "dueDate": dueDateString]
        if let description = task.description {
            params["description"] = description
        }
        
        Alamofire.request(.POST, "\(baseURL)/tasks", parameters: params, encoding: .JSON)
            .responseJSON { response in
                switch response.result {
                case .Success(let jsonObj):
                    if let statusCode = response.response?.statusCode where statusCode >= 300 {
                        let errorMessage = (jsonObj as? [String: String])?["errorMessage"]
                        promise.failure(.ErrorResponse(statusCode: statusCode, message: errorMessage))
                        return
                    }
                    
                    do {
                        let responseBody: CreateTaskResponseBody = try decodeValue(jsonObj)
                        promise.success(responseBody.id)
                    } catch let e {
                        promise.failure(.InvalidResponse(e: e, body: jsonObj))
                    }
                case .Failure(let error):
                    promise.failure(.RequestFailed(e: error))
                }
            }
        
        return promise.future
    }
    
}

private struct CreateTaskResponseBody {
    let id: String
}

extension CreateTaskResponseBody: Decodable {
    
    static func decode(e: Extractor) throws -> CreateTaskResponseBody {
        return try CreateTaskResponseBody(
            id: e <| "id"
        )
    }
    
}

import Foundation
import BrightFutures
import Himotoki

class CreateTaskAPIClient {
    
    private let restTemplate = RestTemplate()
    
    func create(task: CreateTask) -> Future<String, APIClientError> {
        let dueDateString = DateFormatter.dueDateFormatter.stringFromDate(task.dueDate)
        
        var params: [String: AnyObject] = ["title": task.title, "dueDate": dueDateString]
        if let description = task.description {
            params["description"] = description
        }
        
        return self.restTemplate.post("/tasks", params: params) { jsonObj in
            let responseBody: CreateTaskResponseBody = try decodeValue(jsonObj)
            return responseBody.id
        }
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

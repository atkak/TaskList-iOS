import Foundation
import BrightFutures
import Himotoki

class FetchTaskListAPIClient {
    
    private let restTemplate = RestTemplate()
    
    func findAll() -> Future<[Task], APIClientError> {
        return self.restTemplate.get("/tasks", params: nil) { jsonObj in
            return try decodeArray(jsonObj)
        }
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
            dueDate: try DateTransformer.apply(e <| "dueDate"),
            completed: e <| "completed"
        )
    }
    
}

enum TaskDecodeError: ErrorType {
    case DateFormat
}

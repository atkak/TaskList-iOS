import Foundation
import BrightFutures

class FetchTaskListService {
    
    private let fetchTaskListAPIClient = FetchTaskListAPIClient()
    
    func findAll() -> Future<[Task], APIClientError> {
        return fetchTaskListAPIClient.findAll()
    }
    
}
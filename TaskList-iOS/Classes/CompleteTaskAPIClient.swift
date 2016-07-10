import Foundation
import BrightFutures

class CompleteTaskAPIClient {
    
    private let restTemplate = RestTemplate()
    
    func complete(id: String) -> Future<Void, APIClientError> {
        let path = buildPath(id)
        
        return restTemplate.post(path, params: nil) { _ in () }
    }
    
    private func buildPath(id: String) -> String {
        return "/tasks/\(id)/complete"
    }
    
}

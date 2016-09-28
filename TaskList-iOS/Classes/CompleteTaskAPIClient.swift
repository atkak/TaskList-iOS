import Foundation
import RxSwift

class CompleteTaskAPIClient {
    
    private let restTemplate = RestTemplate()
    
    func complete(id: String) -> Observable<Void> {
        let path = buildPath(id)
        
        return restTemplate.post(path, params: nil) { _ in () }
    }
    
    private func buildPath(id: String) -> String {
        return "/tasks/\(id)/complete"
    }
    
}

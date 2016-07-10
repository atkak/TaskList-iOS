import Foundation
import BrightFutures

class CompleteTaskService {
    
    private let completeTaskAPIClient = CompleteTaskAPIClient()
    
    func complete(task: Task) -> Future<Void, ApplicationError> {
        return completeTaskAPIClient
            .complete(task.id)
            .asVoid()
            .mapError { $0.translateToApplicationError() }
    }
    
}

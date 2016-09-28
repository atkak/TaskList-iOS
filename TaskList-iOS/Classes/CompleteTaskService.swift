import Foundation
import RxSwift

class CompleteTaskService {
    
    private let completeTaskAPIClient = CompleteTaskAPIClient()
    
    func complete(task: Task) -> Observable<Void> {
        return completeTaskAPIClient
            .complete(task.id)
            .catchError { error in
                if let error = error as? APIClientError {
                    throw error.translateToApplicationError()
                } else {
                    throw error
                }
            }
    }
    
}

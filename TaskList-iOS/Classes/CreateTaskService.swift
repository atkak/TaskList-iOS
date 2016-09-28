import Foundation
import RxSwift

class CreateTaskService {
    
    private let createTaskAPIClient = CreateTaskAPIClient()
    
    func create(task: CreateTask) -> Observable<Void> {
        return createTaskAPIClient.create(task)
            .map { _ in () }
            .catchError { error in
                if let error = error as? APIClientError {
                    throw error.translateToApplicationError()
                } else {
                    throw error
                }
            }
    }
    
}

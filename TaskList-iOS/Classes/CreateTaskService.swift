import Foundation
import BrightFutures

class CreateTaskService {
    
    private let createTaskAPIClient = CreateTaskAPIClient()
    
    func create(task: CreateTask) -> Future<Void, ApplicationError> {
        return createTaskAPIClient.create(task).asVoid().mapError { $0.translateToApplicationError() }
    }
    
}

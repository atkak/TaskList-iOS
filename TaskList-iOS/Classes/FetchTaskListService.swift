import Foundation
import RxSwift

class FetchTaskListService {
    
    private let fetchTaskListAPIClient = FetchTaskListAPIClient()
    
    func findAll() -> Observable<[Task]> {
        return fetchTaskListAPIClient.findAll()
    }
    
}

import Foundation
import BrightFutures

class CompleteTaskService {
    
    func complete(task: Task) -> Future<Void, ApplicationError> {
        // TODO: implement
        let p = Promise<Void, ApplicationError>()
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            p.success(())
        }
        
        return p.future
    }
    
}

import Foundation
import RxSwift

class FetchTaskListService {
    
    private let fetchTaskListAPIClient = FetchTaskListAPIClient()
    
    private let outputPort: TaskListViewOutputPort
    
    init(outputPort: TaskListViewOutputPort) {
        self.outputPort = outputPort
    }
    
    func findAll() {
        fetchTaskListAPIClient.findAll()
            .map { TaskListViewOutputPortEvent.RefreshTaskListComplete(tasks: $0) }
            .bindTo(outputPort.observer)
            .dispose()
    }
    
}

protocol TaskListViewInputPort {
    var refreshTaskListEvent: Observable<Void> { get }
}

protocol TaskListViewOutputPort {
    var observer: AnyObserver<TaskListViewOutputPortEvent> { get }
}

enum TaskListViewOutputPortEvent {
    case RefreshTaskListComplete(tasks: [Task])
}

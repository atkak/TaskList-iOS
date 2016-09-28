import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController {
    
    private let presenter = TaskListPresenter()
    private let disposeBag = DisposeBag()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.taskStream
            .drive(self.tableView.rx_itemsWithCellIdentifier("CellIdentifier")) { _, task, cell in
                cell.textLabel?.text = task.title
                cell.accessoryType = task.completed ? .Checkmark : .None
            }
            .addDisposableTo(disposeBag)
        
        self.presenter.alertEventStream
            .driveNext { alertEvent in
                let alert = UIAlertController(title: alertEvent.title, message: alertEvent.message, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            .addDisposableTo(disposeBag)
        
        self.tableView.rx_itemSelected
            .map { $0.row }
            .bindTo(presenter.onSelected)
            .addDisposableTo(disposeBag)
        
        self.presenter.onRefreshTaskList.on(Event.Next(()))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier where identifier == "PushToDetailForEdit" {
            let destinationViewController = segue.destinationViewController as! TaskDetailViewController
            destinationViewController.task = self.presenter.selectedTask
        }
    }
    
    @IBAction func unwindFromDetailViewFor(segue: UIStoryboardSegue) {
        self.presenter.onRefreshTaskList.on(Event.Next(()))
    }
    
}

class TaskListPresenter: TaskListViewOutputPort {
    private let fetchTaskListService: FetchTaskListService
    
    private let tasks = Variable<[Task]>([])
    
    private let alertEvent = Variable<AlertEvent!>(nil)
    
    private (set) var selectedTask: Task? = nil
    
    private let disposeBag = DisposeBag()
    
    var observer: AnyObserver<TaskListViewOutputPortEvent> {
        return AnyObserver { event in
            switch event {
            case .Next(.RefreshTaskListComplete(let tasks)):
                self.tasks.value = tasks
            default: break
            }
        }
    }
    
    init() {
        taskStream = tasks.asDriver()
        alertEventStream = alertEvent.asDriver().filter { $0 != nil }
        fetchTaskListService = FetchTaskListService(outputPort: self)
    }
    
    let taskStream: Driver<[Task]>
    
    let alertEventStream: Driver<AlertEvent!>
    
    var onSelected: AnyObserver<Int> {
        return AnyObserver(eventHandler: bindSelectedTask)
    }
    
    private func bindSelectedTask(event: Event<Int>) {
        if case let .Next(index) = event {
            selectedTask = tasks.value[index]
        }
    }
    
    var onRefreshTaskList: AnyObserver<Void> {
        return AnyObserver { _ in
            self.loadTasks()
        }
    }
    
    private var onRefreshTaskListComplete: AnyObserver<[Task]> {
        return AnyObserver { event in
            switch event {
            case let .Next(tasks):
                self.tasks.value = tasks
                
            case .Error(_):
                self.alertEvent.value = AlertEvent(message: "Fail to load tasks")
                
            case .Completed: break
            }
        }
    }
    
    private func loadTasks() {
        fetchTaskListService.findAll()
//            .observeOn(MainScheduler.instance)
//            .bindTo(onRefreshTaskListComplete)
//            .subscribe { [unowned self] in
//                switch $0 {
//                case let .Next(tasks):
//                self.tasks.value = tasks
//                    
//                case .Error(_):
//                self.alertEvent.value = AlertEvent(message: "Fail to load tasks")
//                    
//                case .Completed: break
//                }
//            }
//            .addDisposableTo(disposeBag)
    }
}

struct AlertEvent {
    let title: String? = nil
    let message: String
}


import UIKit
import BrightFutures
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
        
        self.presenter.loadTasks()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier where identifier == "PushToDetailForEdit" {
            let destinationViewController = segue.destinationViewController as! TaskDetailViewController
            destinationViewController.task = self.presenter.selectedTask
        }
    }
    
    @IBAction func unwindFromDetailViewFor(segue: UIStoryboardSegue) {
        self.presenter.loadTasks()
    }
    
}

class TaskListPresenter {
    private let fetchTaskListService = FetchTaskListService()
    
    private let tasks = Variable<[Task]>([])
    
    private let alertEvent = Variable<AlertEvent!>(nil)
    
    private (set) var selectedTask: Task? = nil
    
    init() {
        taskStream = tasks.asDriver()
        alertEventStream = alertEvent.asDriver().filter { $0 != nil }
    }
    
    let taskStream: Driver<[Task]>
    
    let alertEventStream: Driver<AlertEvent!>
    
    private func bindSelectedTask(event: Event<Int>) {
        if case let .Next(index) = event {
            selectedTask = tasks.value[index]
        }
    }
    
    var onSelected: AnyObserver<Int> {
        return AnyObserver(eventHandler: bindSelectedTask)
    }
    
    func loadTasks() {
        let future = fetchTaskListService.findAll()
        future
            .onSuccess(Queue.main.context) { [unowned self] in
                self.tasks.value = $0
            }
            .onFailure(Queue.main.context) { [unowned self] _ in
                self.alertEvent.value = AlertEvent(message: "Fail to load tasks")
            }
    }
}

struct AlertEvent {
    let title: String? = nil
    let message: String
}


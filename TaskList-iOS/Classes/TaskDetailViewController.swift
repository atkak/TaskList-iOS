import UIKit
import Eureka
import PKHUD
import BrightFutures

class TaskDetailViewController: FormViewController {
    
    private let createTaskService = CreateTaskService()
    private let completeTaskService = CompleteTaskService()
    
    var task: Task?
    
    var editState: Bool {
        return self.task != nil
    }
    
    var createState: Bool {
        return self.task == nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildForm(self.task)
    }
    
    private func buildForm(task: Task?) {
        form
            +++ Section("Contents")
            <<< TextRow() {
                $0.title = "Title"
                $0.tag = "title"
                $0.value = task?.title
                $0.disabled = self.editState ? true : false
            }
            <<< TextRow() {
                $0.title = "Description"
                $0.tag = "description"
                $0.value = task?.description
                $0.disabled = self.editState ? true : false
            }
            <<< DateTimeInlineRow {
                $0.title = "Due Date"
                $0.tag = "dueDate"
                $0.value = task?.dueDate
                $0.disabled = self.editState ? true : false
            }
            +++ Section()
            <<< ButtonRow() {
                $0.title = "Save"
                $0.tag = "saveButton"
                $0.hidden = self.editState ? true : false
                $0.disabled = Condition.Function(["title", "dueDate"]) { _ in
                    return self.checkIfEnableToSave()
                }
            }.onCellSelection(self.saveButtonDidTouch)
            <<< ButtonRow() {
                $0.title = "Complete"
                $0.tag = "completeButton"
                $0.hidden = (self.createState || (self.task != nil && task!.completed)) ? true : false
            }.onCellSelection(self.completeButtonDidTouch)
    }
    
    private func checkIfEnableToSave() -> Bool {
        return self.buildCreateTask() == nil
    }
    
    private func buildCreateTask() -> CreateTask? {
        let values = self.form.values()
        
        guard let title = values["title"] as? String where title.characters.count > 0 else {
            return nil
        }
        
        let description = values["description"] as? String
        
        guard let dueDate = values["dueDate"] as? NSDate else {
            return nil
        }
        
        return CreateTask(title: title, description: description, dueDate: dueDate)
    }
    
    private func saveButtonDidTouch(cell: ButtonRow.Cell, row: ButtonRow) {
        saveTask()
    }
    
    private func saveTask() {
        guard let task = buildCreateTask() else {
            return
        }
        
        self.executeRemoteTask(self.createTaskService.create(task)) {
            self.popToListView()
        }
    }
    
    private func completeButtonDidTouch(cell: ButtonRow.Cell, row: ButtonRow) {
        completeTask()
    }
    
    private func completeTask() {
        self.executeRemoteTask(self.completeTaskService.complete(self.task!)) {
            self.popToListView()
        }
    }
    
    private func popToListView() {
        self.performSegueWithIdentifier("UnwindFromDetailToList", sender: self)
    }
    
    private func executeRemoteTask<T>(
        @autoclosure executor: () -> Future<T, ApplicationError>,
                     resultHandler: T -> Void
        ) {
        HUD.show(.Progress)
        
        executor()
            .onSuccess(Queue.main.context) { result in
                HUD.flash(.Success, delay: 1.0)
                resultHandler(result)
            }
            .onFailure(Queue.main.context) { error in
                HUD.hide(animated: false)
                let alert = UIAlertController(title: nil, message: error.message, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
    }
    
}

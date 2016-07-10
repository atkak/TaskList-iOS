import UIKit
import Eureka
import PKHUD
import BrightFutures

class TaskDetailViewController: FormViewController {
    
    let createTaskService = CreateTaskService()
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildForm()
    }
    
    private func buildForm() {
        form
            +++ Section("Contents")
            <<< TextRow() {
                $0.title = "Title"
                $0.tag = "title"
            }
            <<< TextRow() {
                $0.title = "Description"
                $0.tag = "description"
            }
            <<< DateTimeInlineRow {
                $0.title = "Due Date"
                $0.tag = "dueDate"
            }
            +++ Section()
            <<< ButtonRow() {
                $0.title = "Save"
                $0.tag = "saveButton"
                $0.disabled = Condition.Function(["title", "dueDate"]) { _ in
                    return self.checkIfEnableToSave()
                }
            }.onCellSelection(self.saveButtonDidTouch)
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
        
        HUD.show(.Progress)
        
        self.createTaskService.create(task)
            .onSuccess(Queue.main.context) {
                HUD.flash(.Success, delay: 1.0)
                self.performSegueWithIdentifier("UnwindFromDetailToList", sender: self)
            }
            .onFailure(Queue.main.context) { error in
                HUD.hide(animated: false)
                let alert = UIAlertController(title: nil, message: error.message, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
    }
    
}

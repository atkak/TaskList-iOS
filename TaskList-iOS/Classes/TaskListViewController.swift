//
//  ViewController.swift
//  TaskList-iOS
//
//  Created by KAKEGAWA Atsushi on 2016/06/24.
//  Copyright © 2016年 KAKEGAWA Atsushi. All rights reserved.
//

import UIKit
import BrightFutures

class TaskListViewController: UITableViewController {
    
    private var tasks: [Task]?
    private let fetchTaskListService = FetchTaskListService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTasks()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath)
        cell.textLabel?.text = self.tasks?[indexPath.row].title
        
        return cell
    }
    
    private func loadTasks() {
        let future = fetchTaskListService.findAll()
        future
            .onSuccess(Queue.main.context) {
                self.tasks = $0
                self.tableView.reloadData()
            }
            .onFailure(Queue.main.context) { error in
                let alert = UIAlertController(title: nil, message: "Fail to load tasks", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
    }

}



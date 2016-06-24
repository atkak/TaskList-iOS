//
//  ViewController.swift
//  TaskList-iOS
//
//  Created by KAKEGAWA Atsushi on 2016/06/24.
//  Copyright © 2016年 KAKEGAWA Atsushi. All rights reserved.
//

import UIKit

class TaskListViewController: UITableViewController {
    
    private var tasks: [String]
    
    required init?(coder aDecoder: NSCoder) {
        self.tasks = [
            "aaa",
            "bbb",
            "ccc"
        ]
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath)
        cell.textLabel?.text = self.tasks[indexPath.row]
        
        return cell
    }

}



//
//  CreateTaskService.swift
//  TaskList-iOS
//
//  Created by KAKEGAWA Atsushi on 2016/07/03.
//  Copyright © 2016年 KAKEGAWA Atsushi. All rights reserved.
//

import Foundation
import BrightFutures

class CreateTaskService {
    
    func create(task: CreateTask) -> Future<Void, Error> {
        // TODO: implement
        let p = Promise<Void, Error>()
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            p.success()
        }
        
        return p.future
    }
    
    enum Error: ErrorType {
        case ServerError
    }
    
}

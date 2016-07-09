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
    
    private let createTaskAPIClient = CreateTaskAPIClient()
    
    func create(task: CreateTask) -> Future<Void, ApplicationError> {
        return createTaskAPIClient.create(task).asVoid().mapError { $0.translateToApplicationError() }
    }
    
}

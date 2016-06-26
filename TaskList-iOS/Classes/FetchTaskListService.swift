//
//  FetchTaskListService.swift
//  TaskList-iOS
//
//  Created by KAKEGAWA Atsushi on 2016/06/25.
//  Copyright © 2016年 KAKEGAWA Atsushi. All rights reserved.
//

import Foundation
import BrightFutures

class FetchTaskListService {
    
    private let fetchTaskListAPIClient = FetchTaskListAPIClient()
    
    func findAll() -> Future<[Task], APIClientError> {
        return fetchTaskListAPIClient.findAll()
    }
    
}
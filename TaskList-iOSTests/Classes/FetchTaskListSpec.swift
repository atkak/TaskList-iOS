//
//  FetchTaskListTests.swift
//  TaskList-iOS
//
//  Created by KAKEGAWA Atsushi on 2016/06/25.
//  Copyright © 2016年 KAKEGAWA Atsushi. All rights reserved.
//

import XCTest
@testable import TaskList_iOS
import Quick
import Nimble
import BrightFutures
import Result
import Mockingjay

class FetchTaskListSpec: QuickSpec {
    
    var tasks: [Task]!
    
    override func spec() {
        
        describe("fetching task list") {
            
            beforeEach {
                let body = [
                    ["id": "id1", "title": "title1", "description": "description1", "dueDate": "2016-06-25T15:00:00"],
                    ["id": "id2", "title": "title2", "description": "description2", "dueDate": "2016-06-25T15:00:01"],
                    ["id": "id3", "title": "title3", "description": "description3", "dueDate": "2016-06-25T15:00:02"],
                ]
                self.stub(http(.GET, uri: "/tasks"), builder: json(body))
            }
            
            it("should return expected task list") {
                let service = FetchTaskListService()
                
                let f = service.findAll()
                
                expect(f.value).toEventually(haveCount(3))
            }
            
        }
        
    }
    
}

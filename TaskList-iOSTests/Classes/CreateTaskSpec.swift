//
//  CreateTaskSpec.swift
//  TaskList-iOS
//
//  Created by KAKEGAWA Atsushi on 2016/07/09.
//  Copyright © 2016年 KAKEGAWA Atsushi. All rights reserved.
//

import XCTest
@testable import TaskList_iOS
import Quick
import Nimble
import BrightFutures
import Result
import Mockingjay

class CreateTaskSpec: QuickSpec {
    
    override func spec() {
        
        describe("create new task") {
            
        let service = CreateTaskService()
        
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let dueDate = calendar?.dateWithEra(-1, year: 2016, month: 7, day: 5, hour: 23, minute: 0, second: 0, nanosecond: 0)!
        
        let task = CreateTask(title: "testTitle", description: "testDescription", dueDate: dueDate!)
        
            context("when operation suceeded") {
                
                let body = ["id": "testId"]
                
                beforeEach {
                    self.stub(http(.POST, uri: "/tasks"), builder: json(body))
                }
                
                it("should return expected successful result") {
                    let f = service.create(task)
                    
                    expect(f.isSuccess).toEventually(beTrue())
                }
                
            }
            
            context("when operation failed") {
                
                let body = "\"errorMessage\": \"testErrorMessage\"".dataUsingEncoding(NSUTF8StringEncoding)
                
                beforeEach {
                    self.stub(http(.POST, uri: "/tasks"), builder: http(400, data: body))
                }
                
                it("should return expected error") {
                    let f = service.create(task)
                    
                    expect(f.isFailure).toEventually(beTrue())
                    
                    expect(f.error).toNotEventually(beNil())
                    expect(f.error!).toEventually(matchError(ApplicationError(message: "testErrorMessage")))
                }
                
            }
            
        }
        
    }
    
}

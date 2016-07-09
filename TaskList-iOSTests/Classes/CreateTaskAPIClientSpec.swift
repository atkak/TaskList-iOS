//
//  CreateTaskAPIClientSpec.swift
//  TaskList-iOS
//
//  Created by KAKEGAWA Atsushi on 2016/07/05.
//  Copyright © 2016年 KAKEGAWA Atsushi. All rights reserved.
//

import XCTest
@testable import TaskList_iOS
import Quick
import Nimble
import BrightFutures
import Result
import Mockingjay

class CreateTaskAPIClientSpec: QuickSpec {
    
    override func spec() {
        
        describe("create") {
            
            let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
            let dueDate = calendar?.dateWithEra(-1, year: 2016, month: 7, day: 5, hour: 23, minute: 0, second: 0, nanosecond: 0)!
            
            let task = CreateTask(title: "testTitle", description: "testDescription", dueDate: dueDate!)
            
            context("when post operation succeeded") {
                
                let apiClient = CreateTaskAPIClient()
                
                
                beforeEach {
                    self.stub(http(.POST, uri: "/tasks"), builder: json(["id": "testId"]))
                }
                
                it ("should return successful result") {
                    let f: Future<String, APIClientError> = apiClient.create(task)
                    
                    expect(f.isSuccess).toEventually(beTrue())
                    expect(f.value!).toEventually(equal("testId"))
                }
                
            }
            
            context("when not connected to internet") {
            
                let apiClient = CreateTaskAPIClient()
                let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
                
                beforeEach {
                    self.stub(http(.POST, uri: "/tasks"), builder: failure(error))
                }
                
                it("should return failure result") {
                    let f = apiClient.create(task)
                    
                    expect(f.isFailure).toEventually(beTrue())
                    
                    expect(f.error).toNotEventually(beNil())
                    expect(f.error!).toEventually(matchError(APIClientError.RequestFailed(e: error)))
                }
                
            }
            
            context("when http status 400 received") {
            
                let apiClient = CreateTaskAPIClient()
                let body = "{\"errorMessage\":\"dummy\"}".dataUsingEncoding(NSUTF8StringEncoding)
                
                beforeEach {
                    self.stub(http(.POST, uri: "/tasks"), builder: http(400, data: body))
                }
                
                it("should return failure result") {
                    let f = apiClient.create(task)
                    
                    expect(f.isFailure).toEventually(beTrue())
                    
                    expect(f.error).toNotEventually(beNil())
                    expect(f.error!).toEventually(matchError(APIClientError.ErrorResponse(statusCode: 400, message: "dummy")))
                }
                
            }
            
            context("when http status 500 received") {
            
                let apiClient = CreateTaskAPIClient()
                let body = "{\"errorMessage\":\"dummy\"}".dataUsingEncoding(NSUTF8StringEncoding)
                
                beforeEach {
                    self.stub(http(.POST, uri: "/tasks"), builder: http(500, data: body))
                }
                
                it("should return failure result") {
                    let f = apiClient.create(task)
                    
                    expect(f.isFailure).toEventually(beTrue())
                    
                    expect(f.error).toNotEventually(beNil())
                    expect(f.error!).toEventually(matchError(APIClientError.ErrorResponse(statusCode: 500, message: "dummy")))
                }
                
            }
            
        }
        
    }
    
}

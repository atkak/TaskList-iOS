//
//  FetchTaskListAPIClientSpec.swift
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

class FetchTaskListAPIClientSpec: QuickSpec {
    
    override func spec() {
        
        describe("findAll") {
            
            context("when response is expected") {
            
                let apiClient = FetchTaskListAPIClient()
                let body = [
                    ["id": "id1", "title": "title1", "description": "description1", "dueDate": "2016-06-25T15:00:00"],
                    ["id": "id2", "title": "title2", "description": "description2", "dueDate": "2016-06-25T15:00:01"],
                    ["id": "id3", "title": "title3", "description": "description3", "dueDate": "2016-06-25T15:00:02"],
                    ]
                
                beforeEach {
                    self.stub(http(.GET, uri: "/tasks"), builder: json(body))
                }
                
                it("should return successful result") {
                    let f = apiClient.findAll()
                    
                    expect(f.isSuccess).toEventually(beTrue())
                    
                    let tasks = f.result?.value
                    
                    expect(tasks).toEventually(haveCount(3))
                    expect(tasks?[0].id).toEventually(equal("id1"))
                    expect(tasks?[0].title).toEventually(equal("title1"))
                    expect(tasks?[0].description).toEventually(equal("description1"))
                    
                    let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
                    let date = calendar.dateWithEra(1, year: 2016, month: 6, day: 25, hour: 15, minute: 0, second: 0, nanosecond: 0)
                    
                    expect(tasks?[0].dueDate).toEventually(equal(date))
                }
                
            }
            
            context("when description field does not exist") {
            
                let apiClient = FetchTaskListAPIClient()
                let body = [
                    ["id": "id1", "title": "title1", "dueDate": "2016-06-25T15:00:00"],
                    ]
                
                beforeEach {
                    self.stub(http(.GET, uri: "/tasks"), builder: json(body))
                }
                
                it("should return successful result") {
                    let f = apiClient.findAll()
                    
                    expect(f.isSuccess).toEventually(beTrue())
                    
                    let tasks = f.result?.value
                    
                    expect(tasks?[0].id).toEventually(equal("id1"))
                    expect(tasks?[0].title).toEventually(equal("title1"))
                    expect(tasks?[0].description).toEventually(beNil())
                    
                    let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
                    let date = calendar.dateWithEra(1, year: 2016, month: 6, day: 25, hour: 15, minute: 0, second: 0, nanosecond: 0)
                    
                    expect(tasks?[0].dueDate).toEventually(equal(date))
                }
                
            }
            
            context("when not connected to internet") {
            
                let apiClient = FetchTaskListAPIClient()
                let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
                
                beforeEach {
                    self.stub(http(.GET, uri: "/tasks"), builder: failure(error))
                }
                
                it("should return failure result") {
                    let f = apiClient.findAll()
                    
                    expect(f.isFailure).toEventually(beTrue())
                    
                    let resultError = f.result?.error
                    
                    expect(resultError).toNotEventually(beNil())
                    expect(resultError!).toEventually(matchError(APIClientError.RequestFailed(e: error)))
                }
                
            }
            
            context("when http status 500 received") {
            
                let apiClient = FetchTaskListAPIClient()
                let body = "{\"errorMessage\":\"dummy\"}".dataUsingEncoding(NSUTF8StringEncoding)
                
                beforeEach {
                    self.stub(http(.GET, uri: "/tasks"), builder: http(500, data: body))
                }
                
                it("should return failure result") {
                    let f = apiClient.findAll()
                    
                    expect(f.isFailure).toEventually(beTrue())
                    
                    let resultError = f.result?.error
                    
                    expect(resultError).toNotEventually(beNil())
                    expect(resultError!).toEventually(matchError(APIClientError.ErrorResponse(statusCode: 500, message: "dummy")))
                }
                
            }
            
        }
        
    }
    
}

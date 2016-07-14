import XCTest
@testable import TaskList_iOS
import Quick
import Nimble
import BrightFutures
import Result
import Mockingjay

class CompleteTaskSpec: QuickSpec {
    
    override func spec() {
        
        describe("complete task") {
            
            let service = CompleteTaskService()
            
            let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
            let dueDate = calendar?.dateWithEra(-1, year: 2016, month: 7, day: 5, hour: 23, minute: 0, second: 0, nanosecond: 0)!
            
            let task = Task(id: "testId", title: "testTitle", description: "testDescription", dueDate: dueDate!, completed: true)
            
            context("when operation suceeded") {
                
                beforeEach {
                    self.stub(http(.POST, uri: "/tasks/testId/complete"), builder: http(200))
                }
                
                it("should return expected successful result") {
                    let f = service.complete(task)
                    
                    expect(f.isSuccess).toEventually(beTrue())
                }
                
            }
            
            context("when operation failed") {
                
                let body = "\"errorMessage\": \"testErrorMessage\"".dataUsingEncoding(NSUTF8StringEncoding)
                
                beforeEach {
                    self.stub(http(.POST, uri: "/tasks/testId/complete"), builder: http(400, data: body))
                }
                
                it("should return expected error") {
                    let f = service.complete(task)
                    
                    expect(f.isFailure).toEventually(beTrue())
                    
                    expect(f.error).toNotEventually(beNil())
                    expect(f.error!).toEventually(matchError(ApplicationError(message: "testErrorMessage")))
                }
                
            }
            
        }
        
    }
    
}

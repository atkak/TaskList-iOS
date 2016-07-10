import XCTest
@testable import TaskList_iOS
import Quick
import Nimble
import BrightFutures
import Result
import Mockingjay

class CompleteTaskAPIClientSpec: QuickSpec {
    
    override func spec() {
        
        describe("create") {
            
            let id = "testId"
            
            context("when post operation succeeded") {
                
                let apiClient = CompleteTaskAPIClient()
                
                beforeEach {
                    self.stub(http(.POST, uri: "/tasks/\(id)/complete"), builder: http(200))
                }
                
                it ("should return successful result") {
                    let f: Future<Void, APIClientError> = apiClient.complete(id)
                    
                    expect(f.isSuccess).toEventually(beTrue())
                }
                
            }
            
            context("when not connected to internet") {
            
                let apiClient = CompleteTaskAPIClient()
                let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
                
                beforeEach {
                    self.stub(http(.POST, uri: "/tasks/\(id)/complete"), builder: failure(error))
                }
                
                it("should return failure result") {
                    let f = apiClient.complete("testId")
                    
                    expect(f.isFailure).toEventually(beTrue())
                    
                    expect(f.error).toNotEventually(beNil())
                    expect(f.error!).toEventually(matchError(APIClientError.RequestFailed(e: error)))
                }
                
            }
            
            context("when http status 409 received") {
            
                let apiClient = CompleteTaskAPIClient()
                let body = "{\"errorMessage\":\"dummy\"}".dataUsingEncoding(NSUTF8StringEncoding)
                
                beforeEach {
                    self.stub(http(.POST, uri: "/tasks/\(id)/complete"), builder: http(409, data: body))
                }
                
                it("should return failure result") {
                    let f = apiClient.complete("testId")
                    
                    expect(f.isFailure).toEventually(beTrue())
                    
                    expect(f.error).toNotEventually(beNil())
                    expect(f.error!).toEventually(matchError(APIClientError.ErrorResponse(statusCode: 409, message: "dummy")))
                }
                
            }
            
            context("when http status 500 received") {
            
                let apiClient = CompleteTaskAPIClient()
                let body = "{\"errorMessage\":\"dummy\"}".dataUsingEncoding(NSUTF8StringEncoding)
                
                beforeEach {
                    self.stub(http(.POST, uri: "/tasks/\(id)/complete"), builder: http(500, data: body))
                }
                
                it("should return failure result") {
                    let f = apiClient.complete("testId")
                    
                    expect(f.isFailure).toEventually(beTrue())
                    
                    expect(f.error).toNotEventually(beNil())
                    expect(f.error!).toEventually(matchError(APIClientError.ErrorResponse(statusCode: 500, message: "dummy")))
                }
                
            }
        }
    }
}

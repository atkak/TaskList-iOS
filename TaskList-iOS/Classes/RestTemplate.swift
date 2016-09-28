import Foundation
import Alamofire
import RxSwift

class RestTemplate {
    
    func get<T>(
        path: String,
        params: [String: AnyObject]?,
        responseBodyParser: AnyObject throws -> T
        ) -> Observable<T> {
        
        return self.send(.GET, path: path, params: params, responseBodyParser: responseBodyParser)
    }
    
    func post<T>(
        path: String,
        params: [String: AnyObject]?,
        responseBodyParser: AnyObject throws -> T
        ) -> Observable<T> {
        
        return self.send(.POST, path: path, params: params, responseBodyParser: responseBodyParser)
    }
    
    private func send<T>(
        method: Alamofire.Method,
        path: String,
        params: [String: AnyObject]?,
        responseBodyParser: AnyObject throws -> T
        ) -> Observable<T> {
        
        let baseURL = AppConfiguration.webAPIBaseURL
        
        return Observable.create { observer in
        
            let request = Alamofire.request(method, "\(baseURL)\(path)", parameters: params, encoding: .JSON)
                .response { request, response, data, error in
                    if let statusCode = response?.statusCode where method != .GET && statusCode < 300 && data?.length == 0 {
                        do {
                            let result: T = try responseBodyParser(data!)
                            observer.onNext(result)
                            observer.onCompleted()
                        } catch let e {
                            observer.onError(APIClientError.InvalidResponse(e: e, body: data!))
                        }
                        return
                    }
                    
                    let result = Request.JSONResponseSerializer().serializeResponse(request, response, data, error)
                    switch result {
                    case .Success(let jsonObj):
                        if let statusCode = response?.statusCode where statusCode >= 300 {
                            let errorMessage = (jsonObj as? [String: String])?["errorMessage"]
                            observer.onError(APIClientError.ErrorResponse(statusCode: statusCode, message: errorMessage))
                            return
                        }
                        
                        do {
                            let result: T = try responseBodyParser(jsonObj)
                            observer.onNext(result)
                            observer.onCompleted()
                        } catch let e {
                            observer.onError(APIClientError.InvalidResponse(e: e, body: jsonObj))
                        }
                    case .Failure(let error):
                        observer.onError(APIClientError.RequestFailed(e: error))
                    }
                }
            
            return AnonymousDisposable {
                request.cancel()
            }
        }
    }
    
}

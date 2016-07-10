import Foundation
import Alamofire
import BrightFutures

class RestTemplate {
    
    func get<T>(
        path: String,
        params: [String: AnyObject]?,
        responseBodyParser: AnyObject throws -> T
        ) -> Future<T, APIClientError> {
        
        return self.send(.GET, path: path, params: params, responseBodyParser: responseBodyParser)
    }
    
    func post<T>(
        path: String,
        params: [String: AnyObject]?,
        responseBodyParser: AnyObject throws -> T
        ) -> Future<T, APIClientError> {
        
        return self.send(.POST, path: path, params: params, responseBodyParser: responseBodyParser)
    }
    
    private func send<T>(
        method: Alamofire.Method,
        path: String,
        params: [String: AnyObject]?,
        responseBodyParser: AnyObject throws -> T
        ) -> Future<T, APIClientError> {
        
        let baseURL = AppConfiguration.webAPIBaseURL
        let promise = Promise<T, APIClientError>()
        
        Alamofire.request(method, "\(baseURL)\(path)", parameters: params, encoding: .JSON)
            .response { request, response, data, error in
                if let statusCode = response?.statusCode where method != .GET && statusCode < 300 && data?.length == 0 {
                    do {
                        let result: T = try responseBodyParser(data!)
                        promise.success(result)
                    } catch let e {
                        promise.failure(.InvalidResponse(e: e, body: data!))
                    }
                    return
                }
                
                let result = Request.JSONResponseSerializer().serializeResponse(request, response, data, error)
                switch result {
                case .Success(let jsonObj):
                    if let statusCode = response?.statusCode where statusCode >= 300 {
                        let errorMessage = (jsonObj as? [String: String])?["errorMessage"]
                        promise.failure(.ErrorResponse(statusCode: statusCode, message: errorMessage))
                        return
                    }
                    
                    do {
                        let result: T = try responseBodyParser(jsonObj)
                        promise.success(result)
                    } catch let e {
                        promise.failure(.InvalidResponse(e: e, body: jsonObj))
                    }
                case .Failure(let error):
                    promise.failure(.RequestFailed(e: error))
                }
            }
        
        return promise.future
    }
    
}

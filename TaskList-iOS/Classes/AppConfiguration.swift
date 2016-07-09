import Foundation

class AppConfiguration {

    static let webAPIBaseURL: String = {
        return NSBundle.mainBundle().infoDictionary!["WebAPI Base URL"] as! String
    }()

}
    
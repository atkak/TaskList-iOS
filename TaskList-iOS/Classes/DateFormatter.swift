import Foundation

struct DateFormatter {
    
    static let dueDateFormatter = DateFormatter.createDueDateFormatter()
    
    private static func createDueDateFormatter() -> NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
        return dateFormatter
    }
    
}

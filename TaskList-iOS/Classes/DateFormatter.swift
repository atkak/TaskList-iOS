//
//  TaskDateExtension.swift
//  TaskList-iOS
//
//  Created by KAKEGAWA Atsushi on 2016/07/04.
//  Copyright © 2016年 KAKEGAWA Atsushi. All rights reserved.
//

import Foundation

struct DateFormatter {
    
    static let dueDateFormatter = DateFormatter.createDueDateFormatter()
    
    private static func createDueDateFormatter() -> NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
        return dateFormatter
    }
    
}

//
//  AppConfiguration.swift
//  TaskList-iOS
//
//  Created by KAKEGAWA Atsushi on 2016/07/03.
//  Copyright © 2016年 KAKEGAWA Atsushi. All rights reserved.
//

import Foundation

class AppConfiguration {

    static let webAPIBaseURL: String = {
        return NSBundle.mainBundle().infoDictionary!["WebAPI Base URL"] as! String
    }()

}
    
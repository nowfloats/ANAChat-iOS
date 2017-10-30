//
//  InputDateModel.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 24/08/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import UIKit

class InputDateModel: NSObject {
    var minYear : String!
    var minMonth : String!
    var minDay : String!
    var maxYear : String!
    var maxMonth : String!
    var maxDay : String!
    var interval : String!
    
    override init ()
    {
        super.init()
    }
    
    convenience init(_ dictionary: Dictionary<String, Any>) {
        self.init()
        if let minInfo = dictionary[Constants.kMinimumKey] as? NSDictionary{
            if let minYear = minInfo[Constants.kYearKey] as? String{
                self.minYear = minYear
            }
            if let minMonth = minInfo[Constants.kMonthKey] as? String{
                self.minMonth = minMonth
            }
            if let minDay = minInfo[Constants.kMdayKey] as? String{
                self.minDay = minDay
            }
        }
        if let maxInfo = dictionary[Constants.kMaximumKey] as? NSDictionary{
            if let maxYear = maxInfo[Constants.kYearKey] as? String{
                self.maxYear = maxYear
            }
            if let maxMonth = maxInfo[Constants.kMonthKey] as? String{
                self.maxMonth = maxMonth
            }
            if let maxDay = maxInfo[Constants.kMdayKey] as? String{
                self.maxDay = maxDay
            }
        }
        if let interval = dictionary[Constants.kIntervalKey] as? String{
            self.interval = interval
        }
    }

}

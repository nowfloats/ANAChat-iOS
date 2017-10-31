//
//  InputTimeModel.swift
//

import UIKit

class InputTimeModel: NSObject {
    
    var minHour : String!
    var minMinute : String!
    var minSecond : String!
    var maxHour : String!
    var maxMinute : String!
    var maxSecond : String!
    var interval : String!
    
    override init ()
    {
        super.init()
    }
    
    convenience init(_ dictionary: Dictionary<String, Any>) {
        self.init()
        if let minInfo = dictionary[Constants.kMinimumKey] as? NSDictionary{
            if let minHour = minInfo[Constants.kHourKey] as? String{
                self.minHour = minHour
            }
            if let minMinute = minInfo[Constants.kMinuteKey] as? String{
                self.minMinute = minMinute
            }
            if let minSecond = minInfo[Constants.kSecondKey] as? String{
                self.minSecond = minSecond
            }
        }
        if let maxInfo = dictionary[Constants.kMaximumKey] as? NSDictionary{
            if let maxHour = maxInfo[Constants.kHourKey] as? String{
                self.maxHour = maxHour
            }
            if let maxMinute = maxInfo[Constants.kMinuteKey] as? String{
                self.maxMinute = maxMinute
            }
            if let maxSecond = maxInfo[Constants.kSecondKey] as? String{
                self.maxSecond = maxSecond
            }
        }
        if let interval = dictionary[Constants.kIntervalKey] as? String{
            self.interval = interval
        }
    }
}

//
//  UIConfigurationUtility.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 30/08/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import UIKit

import Foundation
import UIKit


struct UIConfigurationUtility{
    
    struct Fonts{
        static let TextLblFont = UIFont(name: "HelveticaNeue-Light", size: 15)
        static let TimeLblFont = UIFont(name: "HelveticaNeue-Light", size: 10)
        static let carouselTitleFont = UIFont(name: "Helvetica-Semibold", size: 14)
        static let carouselDescriptionFont = UIFont(name: "HelveticaNeue-Light", size: 12)
        static let carouselOptionsFont = UIFont(name: "Helvetica-Semibold", size: 10)

    }
    
    struct Colors{
        static let BaseThemeColor = UIColor.init(hexString: "#8cc83c")
        static let BackgroundColor = UIColor.init(hexString: "#F1F2F4")
        static let SenderThemeColor = UIColor.init(hexString: "#000000")
        static let MediaDescriptionColor = UIColor.init(hexString: "#FFFFFF")
    }
    
}



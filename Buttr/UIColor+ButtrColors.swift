//
//  UIColor+ButtrColors.swift
//  Buttr
//
//  Created by Kyle Lucovsky on 8/8/15.
//  Copyright (c) 2015 Kyle Lucovsky. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func backgroundColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 249.0/249.0, blue: 196.0/255.0, alpha: 1.0)
    }
    
    class func primaryTextColor() -> UIColor {
        return UIColor(red: 229.0/255.0, green: 182.0/255.0, blue: 106.0/255.0, alpha: 1.0)
    }
    
    class func secondaryTextColor() -> UIColor {
        return UIColor(red: 246.0/255.0, green: 207.0/255.0, blue: 145.0/255.0, alpha: 1.0)
    }
    
    class func tertiaryTextColor() -> UIColor {
        return UIColor(red: 252.0/255.0, green: 233.0/255.0, blue: 203.0/255.0, alpha: 1.0)
    }
}
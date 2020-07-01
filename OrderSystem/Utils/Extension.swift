//
//  extension.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/21.
//  Copyright © 2020 骆荟州. All rights reserved.
//

//对系统类的拓展

import UIKit

extension UIColor {
    static func fromRGB(R: Int, G: Int, B: Int) -> UIColor {
        let r: CGFloat = CGFloat(R) / 255
        let g: CGFloat = CGFloat(G) / 255
        let b: CGFloat = CGFloat(B) / 255
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}

extension Int {
    public func toBool() -> Bool {
        return self > 0 ? true : false
    }
}

extension Int32 {
    public func toBool() -> Bool {
        return self > 0 ? true : false
    }
}

extension Double {
    public func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Float {
    public func roundTo(places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Date {
    public func toString(format: String) -> String {
        let formatter = DateFormatter()
        //设置地区为中国，并设置日期显示格式
        formatter.locale = Locale(identifier: "zh_CN")
        //formatter.setLocalizedDateFormatFromTemplate("yyyy-M-d HH:mm")
        formatter.setLocalizedDateFormatFromTemplate(format)
        return formatter.string(from: self)
    }
    
    public func toTimeStampInSecond() -> Int {
        let timeInterval = self.timeIntervalSince1970
        return Int(timeInterval)
    }
    
    public static func fromTimeStampInSecond(timeStamp: Int) -> Date {
        let interval = TimeInterval(timeStamp)
        return Date(timeIntervalSince1970: interval)
    }
}

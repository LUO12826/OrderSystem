//
//  Dish.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/19.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import Foundation
import UIKit

class Dish: NSObject {
    var Id: Int = 0
    var Name: String = ""
    var Price: Float = 0.0
    var Description: String? = ""
    var IsHot: Bool = false
    var IsRecommand: Bool = false
    var Images = [UIImage]()
    @objc dynamic var Num: Int = 0
    
    
    init(Id: Int, name: String, price: Float, description: String?, isHot: Bool, isRecommand: Bool) {
        self.Id = Id
        self.Name = name
        self.Price = price
        self.Description = description
        self.IsHot = isHot
        self.IsRecommand = isRecommand
    }
}

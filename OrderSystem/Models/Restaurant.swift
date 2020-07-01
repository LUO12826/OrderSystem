//
//  File.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/19.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import Foundation
import UIKit

class Restaurant {
    var Id: Int = 0
    var Name: String = ""
    var Category: String = ""
    var Description: String? = ""
    var Rate: Float = 0.0
    var Address: String? = ""
    //人均消费
    var AvgConsumption: Float = 0.0
    var Images = [UIImage]()
    
    init() {
        
    }
    
    init(id: Int, name: String, category: String, description: String?, rate: Float, address: String?, avgConsumption: Float) {
        self.Id = id
        self.Name = name
        self.Category = category
        self.Description = description
        self.Rate = rate
        self.Address = address
        self.AvgConsumption = avgConsumption
    }
}

//
//  OrderItem.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/22.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import Foundation

class OrderItem {
    private(set) var Id: Int = 0
    private(set) var UnitPrice: Float = 0.0
    private(set) var Num: Int = 0
    private(set) var DishId: Int = 0
    private(set) var Dish: Dish?
    
    var TotalPrice: Float {
        get {
            return UnitPrice * Float(Num)
        }
    }
    
    
    init(id: Int, unitPrice: Float, num: Int, dishId:Int, dish: Dish?) {
        self.Id = id
        self.UnitPrice = unitPrice
        self.Num = num
        self.DishId = dishId
        self.Dish = dish
    }
}

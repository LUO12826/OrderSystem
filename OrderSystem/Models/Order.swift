//
//  Order.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/22.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import Foundation

class Order {
    var Id: Int = 0
    var RestaurantId: Int = 0
    var Restaurant: Restaurant?
    var OrderDate: Date
    var OrderItems: [OrderItem]?
    
    var TotalPrice: Float {
        get {
            guard let items = OrderItems else { return 0.0 }
            var p: Float = 0.0
            for item in items {
                p += item.TotalPrice
            }
            return p
        }
    }
    
    init(id: Int, restaurantId: Int, orderDate: Date) {
        self.Id = id
        self.RestaurantId = restaurantId
        self.OrderDate = orderDate
    }
}

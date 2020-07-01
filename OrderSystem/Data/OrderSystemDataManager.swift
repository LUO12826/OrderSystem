//
//  OrderSystemDataManager.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/22.
//  Copyright © 2020 骆荟州. All rights reserved.
//


import Foundation
import UIKit

enum List: String {
    case RestaurantList = "restaurant"
    case DishesList = "dishes"
}

enum Table: String {
    case order = "order"
    case orderitem = "orderitem"
    case restaurant = "restaurant"
    case dishes = "dishes"
    case about_app = "about_app"
    case developer_info = "developer_info"
}

class OrderSystemDataManager {
    
    static private let db = SQLiteManager.Instance
    static private var queue = DispatchQueue(label: "loadImgQueue")
    
    ///初始化数据库
    static func initDB() {

        if !db.OpenDB() {
            print("打开数据库错误")
            return
        }
        
        if !db.ExecNoneQuerySQL(sql: "PRAGMA foreign_keys=ON;") {
            print("创建数据库失败，无法打开外键模式")
            return
        }
        
        let createRestaurantTable = "CREATE TABLE IF NOT EXISTS 'restaurant' ('id'    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'name'    TEXT NOT NULL,'category'    TEXT NOT NULL,'description'    TEXT,'rate'    REAL NOT NULL,'address'    TEXT,'avg_consumption'    REAL NOT NULL,'list_img' BLOB,'detail_pic' BLOB);"
        
        let createDishesTable = "CREATE TABLE IF NOT EXISTS 'dishes' ('id'    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'restaurant_id'    INTEGER NOT NULL,'name'    TEXT NOT NULL,'price'    REAL NOT NULL,'description'    TEXT,'is_hot'    INTEGER NOT NULL,'is_recommand'    INTEGER NOT NULL,'list_img'    BLOB,'img1'    BLOB,'img2'    BLOB,'img3'    BLOB,FOREIGN KEY(restaurant_id) references restaurant(id));"
        
        let createOrderTable = "CREATE TABLE IF NOT EXISTS 'order' ('id'    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'restaurant_id'    INTEGER NOT NULL,'order_date'    INTEGER NOT NULL,FOREIGN KEY(restaurant_id) references restaurant(id));"
        
        let createOrderItemTable = "CREATE TABLE IF NOT EXISTS 'orderitem' ('id'    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'unit_price'    REAL NOT NULL,'num'    INTEGER NOT NULL,'dish_id'    INTEGER NOT NULL,'order_id'    INTEGER NOT NULL,FOREIGN KEY(dish_id) references dishes(id),FOREIGN KEY(order_id) references [order](id) ON DELETE CASCADE);"
        
        let createAppInfoTable = "CREATE TABLE IF NOT EXISTS 'about_app' ('id'    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'name'    TEXT NOT NULL,'version'    TEXT NOT NULL,'description'    TEXT,'thanks'    TEXT,'icon' BLOB);"
        
        let createDeveloperInfoTable = "CREATE TABLE IF NOT EXISTS 'developer_info' ('id'    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'name'    TEXT NOT NULL,'no'    TEXT NOT NULL,'department'    TEXT,'avatar' BLOB);"
        
        let createSQLs = [createRestaurantTable, createDishesTable, createOrderTable, createOrderItemTable, createAppInfoTable, createDeveloperInfoTable]
        
        for sql in createSQLs {
            if(!db.ExecNoneQuerySQL(sql: sql)) {
                print("执行建表命令\(sql)错误")
            }
        }
        
        db.CloseDB()
    }
    
    ///获取餐厅列表
    static func LoadRestaurantList(completion: (([Restaurant]?) -> Void)?) {
        let sql = "SELECT id,name,category,description,rate,address,avg_consumption FROM restaurant"
        
        DispatchQueue.global(qos: .default).async {
            if !db.OpenDB() {
                print("打开数据库错误")
                return
            }
            
            if let result = db.ExecQuerySQL(sql: sql) {
                
                var restaurants = [Restaurant]()
                
                for item in result {
                    let id = Int(item["id"] as! Int32)
                    let name = item["name"] as! String
                    let category = item["category"] as! String
                    let description = item["description"] as? String
                    let rate = Float(item["rate"] as! Double)
                    let address = item["address"] as? String
                    let avg_consumption = Float(item["avg_consumption"] as! Double)
                    
                    let restaurant = Restaurant(id: id, name: name, category: category, description: description, rate: rate, address: address, avgConsumption: avg_consumption)
                    restaurants.append(restaurant)
                }
                
                DispatchQueue.main.async {
                    completion?(restaurants)
                }
            }
                
            else {
                DispatchQueue.main.async {
                    completion?(nil)
                }
            }
            db.CloseDB()
        }
    }
    
    ///获取列表中的图片，可以是菜品列表或是餐厅列表
    static func LoadListImg(forList list: List, id: Int, completion: ((UIImage?) -> Void)?) {
        let sql = "SELECT list_img FROM \(list.rawValue) WHERE id = \(id)"
        DispatchQueue.global(qos: .default).async {
            queue.sync {
                if !db.OpenDB() {
                    print("打开数据库错误")
                    return
                }
                
                //假如查到结果
                if let result = db.ExecFetchBlob(sql: sql) {
                    //假如结果为空，返回一个空指针
                    guard result.count > 0 else {
                        DispatchQueue.main.async {
                            if let completion = completion {
                                completion(nil)
                            }
                        }
                        db.CloseDB()
                        return
                    }
                    
                    if let imgData = result[0] {
                        let img = UIImage(data: imgData)
                        DispatchQueue.main.async {
                            completion?(img)
                        }
                    }
                    
                }
                //假如查不到结果，返回一个空指针
                else {
                    DispatchQueue.main.async {
                        completion?(nil)
                    }
                }
                db.CloseDB()
            }
        }
    }
    
    ///获取菜品列表
    static func LoadDishesList(for restaruantID: Int, completion: (([Dish]?) -> Void)?) {
        let sql = "SELECT id,name,description,price,is_hot,is_recommand FROM dishes WHERE restaurant_id = \(restaruantID)"
        
        DispatchQueue.global(qos: .default).async {
            if !db.OpenDB() {
                print("打开数据库错误")
                return
            }
            
            if let result = db.ExecQuerySQL(sql: sql) {
                var dishes = [Dish]()
                
                for item in result {
                    let id = Int(item["id"] as! Int32)
                    let name = item["name"] as! String
                    let description = item["description"] as? String
                    let price = Float(item["price"] as! Double)
                    let is_hot = (item["is_hot"] as! Int32).toBool()
                    let is_recommand = (item["is_recommand"] as! Int32).toBool()
                    
                    let dish = Dish(Id: id, name: name, price: price, description: description, isHot: is_hot, isRecommand: is_recommand)
                    dishes.append(dish)
                }
                
                DispatchQueue.main.async {
                    completion?(dishes)
                }
            }
                
            else {
                DispatchQueue.main.async {
                    completion?(nil)
                }
            }
            db.CloseDB()
        }
    }
    
    ///获取菜品详情页图片
    static func LoadDishDetailImg(for dishId: Int, completion: (([UIImage?]?) -> Void)?) {
        let sql = "SELECT img1,img2,img3 FROM dishes WHERE id = \(dishId)"
        DispatchQueue.global(qos: .default).async {
            if !db.OpenDB() {
                print("打开数据库错误")
                return
            }
            
            if let result = db.ExecQuerySQL(sql: sql) {
                
                guard result.count > 0 else {
                    db.CloseDB()
                    return
                }
                
                var imgs = [UIImage?]()
                for imgData in result[0] {
                    if let data = imgData.value as? Data {
                        imgs.append(UIImage(data: data))
                    }
                    else {
                        imgs.append(nil)
                    }
                }
                DispatchQueue.main.async {
                    completion?(imgs)
                }
            }
            else {
                DispatchQueue.main.async {
                    completion?(nil)
                }
            }
            db.CloseDB()
        }
    }
    
    ///获取一列id对应的菜品
    static func LoadDishesList(forDishIdSequence seq: [Int], completion: (([Dish?]) -> Void)?) {
        DispatchQueue.global(qos: .default).async {
            if !db.OpenDB() {
                print("打开数据库错误")
                return
            }
            
            var dishes = [Dish?]()
            for id in seq {
                let dish = LoadDish(forDishId: id)
                dishes.append(dish)
            }
            DispatchQueue.main.async {
                completion?(dishes)
            }
            db.CloseDB()
        }
    }
    
    ///获取订单列表
    static func LoadOrderList(completion: (([Order]?) -> Void)?) {
        let sql = "SELECT id,restaurant_id,order_date FROM [order] ORDER BY order_date DESC"
        
        DispatchQueue.global(qos: .default).async {
            if !db.OpenDB() {
                print("打开数据库错误")
                return
            }
            
            if let result = db.ExecQuerySQL(sql: sql) {
                
                var orders = [Order]()
                
                for item in result {
                    let id = Int(item["id"] as! Int32)
                    let restaurant_id = Int(item["restaurant_id"] as! Int32)
                    let order_date = Int(item["order_date"] as! Int32)
                    
                    let order = Order(id: id, restaurantId: restaurant_id, orderDate: Date.fromTimeStampInSecond(timeStamp: order_date))
                    
                    order.Restaurant = LoadRestaurant(forRestaurant: restaurant_id)
                    order.OrderItems = LoadOrderItems(forOrder: id)
                    orders.append(order)
                }
                
                DispatchQueue.main.async {
                    completion?(orders)
                }
            }
                
            else {
                DispatchQueue.main.async {
                    completion?(nil)
                }
            }
            db.CloseDB()
        }
    }
    
    ///添加订单
    static func AddOrder(order: Order, completion: ((Bool) -> Void)?) {
        DispatchQueue.global(qos: .default).async {
            if !db.OpenDB() {
                print("打开数据库错误")
                DispatchQueue.main.async {
                    completion?(false)
                }
                return
            }
            
            let sql = "INSERT INTO [order] (restaurant_id, order_date) VALUES (\(order.RestaurantId), \(order.OrderDate.toTimeStampInSecond()))"
            
            var result = true
            if db.ExecNoneQuerySQL(sql: sql) && order.OrderItems != nil {
                //这里要先获取最新插入的order的id，才能正确插入orderitem
                if let seq = getSeqForTable(table: .order) {
                    for item in order.OrderItems! {
                        if !AddOrderItem(orderItem: item, toOrder: seq) {
                            result = false
                            break
                        }
                    }
                }
                else {
                    result = false
                }
            }
            else {
                result = false
            }
            DispatchQueue.main.async {
                completion?(result)
            }
        }
    }
    
    ///添加订单明细
    private static func AddOrderItem(orderItem: OrderItem, toOrder id: Int) -> Bool {
        if !db.OpenDB() {
            print("打开数据库错误")
            return false
        }
        
        let sql = "INSERT INTO orderitem (num, unit_price, dish_id, order_id)"
            + " VALUES (\(orderItem.Num), \(orderItem.UnitPrice), \(orderItem.DishId), \(id))"
        let result = db.ExecNoneQuerySQL(sql: sql)
        db.CloseDB()
        return result
    }
    
    ///删除订单
    static func DeleteOrder(withOrderId id: Int, completion: ((Bool) -> Void)?) {
        
        DispatchQueue.global(qos: .default).async {
            if DeleteOrderItem(forOrder: id) {
                if !db.OpenDB() {
                    print("打开数据库错误")
                    return
                }
                let sql = "PRAGMA foreign_keys=ON;DELETE FROM [order] WHERE id = \(id)"
                if db.ExecNoneQuerySQL(sql: sql) {
                    DispatchQueue.main.async {
                        completion?(true)
                    }
                    db.CloseDB()
                    return
                }
            }

            else {
                DispatchQueue.main.async {
                    completion?(false)
                    print("删除订单\(id)出错")
                }
            }
            db.CloseDB()
        }
    }
    
    ///删除订单明细
    private static func DeleteOrderItem(forOrder id: Int) -> Bool {
        if !db.OpenDB() {
            print("打开数据库错误")
            return false
        }
        
        let sql = "DELETE FROM orderitem WHERE order_id = \(id)"
        let result = db.ExecNoneQuerySQL(sql: sql)
        db.CloseDB()
        return result
    }
    
    ///获取订单项目
    private static func LoadOrderItems(forOrder orderId: Int) -> [OrderItem]? {
        let sql = "SELECT * FROM orderitem WHERE order_id = \(orderId)"
        
        if !db.OpenDB() {
            print("打开数据库错误")
            return nil
        }
        
        var items: [OrderItem]?
        if let result = db.ExecQuerySQL(sql: sql) {
            items = [OrderItem]()
            
            for item in result {
                let id = Int(item["id"] as! Int32)
                let num = Int(item["num"] as! Int32)
                let unit_price = Float(item["unit_price"] as! Double)
                let dish_id = Int(item["dish_id"] as! Int32)
                let _ = Int(item["order_id"] as! Int32)
                
                let dish = LoadDish(forDishId: dish_id)
                let orderItem = OrderItem(id: id, unitPrice: unit_price, num: num, dishId: dish_id, dish: dish)
                items!.append(orderItem)
            }
            
        }
        
        db.CloseDB()
        return items
    }
    
    ///加载一个菜品
    private static func LoadDish(forDishId id: Int) -> Dish? {

        if !db.OpenDB() {
            print("打开数据库错误")
            return nil
        }
        
        let sql = "SELECT id,name,description,price,is_hot,is_recommand FROM dishes WHERE id = \(id)"
        var dish: Dish?
        if let result = db.ExecQuerySQL(sql: sql) {
            for item in result {
                let id = Int(item["id"] as! Int32)
                let name = item["name"] as! String
                let description = item["description"] as? String
                let price = Float(item["price"] as! Double)
                let is_hot = (item["is_hot"] as! Int32).toBool()
                let is_recommand = (item["is_recommand"] as! Int32).toBool()
                dish = Dish(Id: id, name: name, price: price, description: description, isHot: is_hot, isRecommand: is_recommand)
                break
            }
        }
            
        db.CloseDB()
        return dish
    }
    
    ///加载一个餐厅
    private static func LoadRestaurant(forRestaurant id: Int) -> Restaurant? {

        if !db.OpenDB() {
            print("打开数据库错误")
            return nil
        }
        
        let sql = "SELECT id,name,category,description,rate,address,avg_consumption FROM restaurant WHERE id = \(id)"
        var restaurant: Restaurant?
        if let result = db.ExecQuerySQL(sql: sql) {
            for item in result {
                let id = Int(item["id"] as! Int32)
                let name = item["name"] as! String
                let category = item["category"] as! String
                let description = item["description"] as? String
                let rate = Float(item["rate"] as! Double)
                let address = item["address"] as? String
                let avg_consumption = Float(item["avg_consumption"] as! Double)
                
                restaurant = Restaurant(id: id, name: name, category: category, description: description, rate: rate, address: address, avgConsumption: avg_consumption)
                break
            }
        }
            
        db.CloseDB()
        return restaurant
    }
    
    static func GetAppInfo(forId id: Int, completion: ((AboutApp?) -> Void)?) {
        DispatchQueue.global(qos: .default).async {
            if !db.OpenDB() {
                print("打开数据库错误")
                DispatchQueue.main.async {
                    completion?(nil)
                }
                return
            }
            
            let sql = "SELECT id,name,version,description,thanks,icon FROM about_app WHERE id = \(id)"
            if let result = db.ExecQuerySQL(sql: sql) {

                var info: AboutApp?
                for item in result {
                    let id = Int(item["id"] as! Int32)
                    let name = item["name"] as! String
                    let version = item["version"] as! String
                    let description = item["description"] as! String
                    let thanks = item["thanks"] as! String
                    let icon = item["icon"] as? Data
                    
                    let img = icon == nil ? UIImage() : UIImage(data: icon!)
                    
                    info = AboutApp(id: id, Name: name, Version: version, Description: description, Thanks: thanks, Icon: img)
                    break
                }
                
                DispatchQueue.main.async {
                    completion?(info)
                }
            }
                
            else {
                DispatchQueue.main.async {
                    completion?(nil)
                }
            }
            db.CloseDB()
        }
    }
    
    static func GetDeveloperInfo(forId id: Int, completion: ((AboutMe?) -> Void)?) {
        DispatchQueue.global(qos: .default).async {
            if !db.OpenDB() {
                print("打开数据库错误")
                DispatchQueue.main.async {
                    completion?(nil)
                }
                return
            }
            
            let sql = "SELECT id,name,no,department,avatar FROM developer_info WHERE id = \(id)"
            if let result = db.ExecQuerySQL(sql: sql) {

                var info: AboutMe?
                for item in result {
                    let id = Int(item["id"] as! Int32)
                    let name = item["name"] as! String
                    let no = item["no"] as! String
                    let department = item["department"] as! String
                    let avatar = item["avatar"] as? Data
                    
                    let img = avatar == nil ? UIImage() : UIImage(data: avatar!)
                    
                    info = AboutMe(id: id, Name: name, No: no, Department: department, Avatar: img)
                    break
                }
                
                DispatchQueue.main.async {
                    completion?(info)
                }
            }
                
            else {
                DispatchQueue.main.async {
                    completion?(nil)
                }
            }
            db.CloseDB()
        }

    }
    
    ///获取自增序列的值
    private static func getSeqForTable(table: Table) -> Int? {
        if !db.OpenDB() {
            print("打开数据库错误")
            return nil
        }
        let sql = "SELECT seq FROM sqlite_sequence WHERE name = '\(table.rawValue)'"
        var seq: Int?
        if let result = db.ExecQuerySQL(sql: sql) {
            for item in result {
                seq = Int(item["seq"] as! Int32)
                break
            }
        }
        db.CloseDB()
        return seq
    }
    
}

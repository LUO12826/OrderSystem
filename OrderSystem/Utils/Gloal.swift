//
//  GloalData.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/22.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import Foundation


class Helper {
    static func WriteDemoDB() {
        let dbName = "orderSystem.sqlite"
        let dbDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(dbName).path
        
        guard !FileManager.default.fileExists(atPath: dbDir) else {return}
        
        let demoDbdir = Bundle.main.path(forResource: "orderSystem", ofType: "sqlite")!
        do {
            try FileManager.default.copyItem(atPath: demoDbdir, toPath: dbDir)
        } catch {
            print("创建演示数据库文件失败")
        }
    }
}

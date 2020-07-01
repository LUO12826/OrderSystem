//
//  SQLiteManager.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/14.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import Foundation

class SQLiteManager: NSObject {
    
    private static let dbName = "orderSystem.sqlite"

    private lazy var dbPath: String! = {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docDir.appendingPathComponent(SQLiteManager.dbName).path
    }()
    
    private var database: OpaquePointer? = nil
    private var isOpened: Bool = false
    
    //多线程打开关闭sqlite可能会提示无效指针访问，实际上是不影响运行的。但看起来不舒服，所以这里用一个queue使得打开关闭是同步的
    private let queue = DispatchQueue(label: "openCloseQueue")
    
    private static var instance: SQLiteManager? = nil
    
    static var Instance: SQLiteManager {
        if instance == nil {
            instance = SQLiteManager()
        }
        return instance!
    }
    
    override init() {
        super.init()
    }
    
    func OpenDB() -> Bool {
        //print(dbPath!)
        queue.sync {
            if isOpened { return true }
            
            let result = sqlite3_open_v2(dbPath, &database, SQLITE_OPEN_CREATE|SQLITE_OPEN_READWRITE|SQLITE_OPEN_FULLMUTEX, nil)
            if result != SQLITE_OK {
                print("打开数据库失败")
                return false
            }
            isOpened = true
            
            return true
        }
    }
    
    func CloseDB() {
        queue.sync {
            if !isOpened { return }
            isOpened = false
            sqlite3_close_v2(database)
        }
    }
    
    func ExecNoneQuerySQL(sql: String) -> Bool {
        var errMsg: UnsafeMutablePointer<Int8>? = nil
        let cSQLstring = sql.cString(using: .utf8)!
        
        
        
        if sqlite3_exec(database, cSQLstring, nil, nil, &errMsg) == SQLITE_OK {
            return true
        }
        
        print("执行非查询语句失败，信息为: ", separator: "", terminator: "")
        print(String(cString: sqlite3_errmsg(database)))
        
        return false
    }
    
    
    func ExecQuerySQL(sql: String) -> [[String: AnyObject]]? {
        let cSQLstring = sql.cString(using: .utf8)!
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(database, cSQLstring, -1, &statement, nil) != SQLITE_OK {
            sqlite3_finalize(statement)
            
            print("执行查询语句：\(sql)错误")
            print(sqlite3_errmsg(database) ?? "")
            
            return nil
        }
        
        var rows = [[String: AnyObject]]()
        while sqlite3_step(statement) == SQLITE_ROW {
            rows.append(fetchRecord(statement: statement!))
        }
        sqlite3_finalize(statement)
        return rows
    }
    
    //通过行句柄，取出一行的数据
    private func fetchRecord(statement: OpaquePointer) -> [String: AnyObject] {
        var row = [String: AnyObject]()
        
        for col in 0..<sqlite3_column_count(statement) {
            let colNameCstring = sqlite3_column_name(statement, col)
            let colName = String(cString: colNameCstring!, encoding: .utf8)!
            
            var value: AnyObject?
            switch sqlite3_column_type(statement, col) {
            case SQLITE_FLOAT:
                value = sqlite3_column_double(statement, col) as AnyObject
            case SQLITE_INTEGER:
                value = sqlite3_column_int(statement, col) as AnyObject
            case SQLITE_TEXT:
                value = String(cString: sqlite3_column_text(statement, col)) as AnyObject
            case SQLITE_BLOB:
                let blob = sqlite3_column_blob(statement, col)!
                let blobLength = sqlite3_column_bytes(statement, col)
                let data = Data(bytes: blob, count: Int(blobLength))
                value = data as AnyObject
                
            case SQLITE_NULL:
                value = nil
            default:
                print("出现不支持的数据类型")
            }
            
            row[colName] = value ?? nil
        }
        
        return row
    }
    
    ///执行存入二进制数据。一次只能存入一个blob。
    func ExecSaveBlobSQL(sql: String, blob: NSData) -> Bool {
        let cSQLstring = sql.cString(using: .utf8)!
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(database, cSQLstring, -1, &statement, nil) != SQLITE_OK {
            sqlite3_finalize(statement)
            
            print("执行存入blob语句：\(sql)错误")
            print(sqlite3_errmsg(database) ?? "")
            return false
        }
        
        if sqlite3_bind_parameter_count(statement) != 1 {
            print("执行存入blob语句必须且只能有1个参数")
            sqlite3_finalize(statement)
            return false
        }
        
        if sqlite3_bind_blob(statement, 1, blob.bytes, Int32(blob.length), nil) != SQLITE_OK {
            print("执行语句：\(sql)时绑定blob错误")
            sqlite3_finalize(statement)
            return false
        }
        
        let result = sqlite3_step(statement)
        if !(result == SQLITE_OK || result == SQLITE_DONE) {
            print("执行语句：\(sql)时发生错误")
            sqlite3_finalize(statement)
            return false
        }
        
        sqlite3_finalize(statement)
        return true
    }
    
    ///执行读取二进制数据
    func ExecFetchBlob(sql: String) -> [Data?]? {
        let cSQLstring = sql.cString(using: .utf8)!
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, cSQLstring, -1, &statement, nil) != SQLITE_OK {
            sqlite3_finalize(statement)
            print("执行读取blob语句：\(sql)时发生错误")
            print(sqlite3_errmsg(database) ?? "")
            return nil
        }
        
        var result = [Data?]()
        while sqlite3_step(statement) == SQLITE_ROW {
            if let blob = sqlite3_column_blob(statement, 0) {
                let blobLength = sqlite3_column_bytes(statement, 0)
                let data = Data(bytes: blob, count: Int(blobLength))
                result.append(data)
            }
            else {
                result.append(nil)
            }
        }
        sqlite3_finalize(statement)
        
        return result
    }
}

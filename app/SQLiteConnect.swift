//
//  SQLiteConnect.swift
//  app
//
//  Created by 張語航 on 2017/8/3.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
import SQLite
class SQLiteConnect {
    var db :Connection!
    let dbPath :String
    init?(file :String) {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        dbPath = urls[urls.count-1].absoluteString + file
        
        print(dbPath)
        
        do {
            db = try Connection(dbPath)
        } catch {
            print(error)
        }
    }
    
    func createTable(_ tableName :String, columnsInfo :[String]) -> Bool {
        let sql = "create table if not exists \(tableName) "
            + "(\(columnsInfo.joined(separator: ",")))"
        do {
            try db.execute(sql)
        } catch {
            print("createTable \(error)")
            return false
        }
        return true
    }
    
    func insert(_ tableName :String, rowInfo :[String:String]) -> Bool {
        let sql = "insert into \(tableName) "
            + "(\(rowInfo.keys.joined(separator: ","))) "
            + "values (\(rowInfo.values.joined(separator: ",")))"
        print(sql)
        do {
            try db.execute(sql)
        } catch {
            print("insert \(error)")
            return false
        }
        return true
    }
    
    func fetch(_ tableName :String, cond :String?/*, order :String?*/) -> [[String:String]] {
        var sql = "select * from \(tableName)"
        if let condition = cond {
            sql += " where \(condition)"
        }
        
//        if let orderBy = order {
//            sql += " order by \(orderBy)"
//        }
        print(sql)
        var stmt :Statement! = nil
        do {
            stmt = try db.prepare(sql)
        } catch {
            
        }
        var data :[[String:String]] = []
        for row in stmt {
            var rowInfo :[String:String] = [:]
            for (index, name) in stmt.columnNames.enumerated(){
                rowInfo["\(name)"] = "\(row[index]!)"
            }
            data.append(rowInfo)
        }
        print (data)
        return data
    }
    
    func update(_ tableName :String, cond :String?, rowInfo :[String:String]) -> Bool {
        var sql = "update \(tableName) set "
        var info :[String] = []
        for (key, value) in rowInfo {
            info.append("\(key) = \(value)")
        }
        sql += info.joined(separator: ",")
        
        if let condition = cond {
            sql += " where \(condition)"
        }
        
        do {
            try db.execute(sql)
        } catch {
            print("insert \(error)")
            return false
        }
        return true
    }
    
    func delete(_ tableName :String, cond:String?) -> Void {
        var sql = "delete from \(tableName)"
        
        if let condition = cond {
            sql += " where \(condition)"
        }
        do {
            try db.execute(sql)
        } catch {
            print("insert \(error)")
            //return false
        }
        //return true
    }
}

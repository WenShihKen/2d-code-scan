//
//  AppDelegate.swift
//  app
//
//  Created by apple on 2017/7/3.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // 建立資料表
        let myUserDefaults = UserDefaults.standard
        let dbInit = myUserDefaults.object(forKey: "dbInit") as? Int
        if dbInit == nil {
            let dbFileName = "ItemData.db"
            let db = SQLiteConnect(file: dbFileName)
            
            if let myDB = db {
                let result = myDB.createTable("Item", columnsInfo: [
                    "Barcode TEXT NOT NULL UNIQUE",
                    "Item_Name text",
                    "Category text",
                    "Prime_Cost INTEGER",
                    "List_Price INTEGER",
                    "Amount INTEGER"
                    ])
                
                if result {
                    myUserDefaults.set(1, forKey: "dbInit")
                    myUserDefaults.set(dbFileName, forKey: "dbFileName")
                    myUserDefaults.synchronize()
                }
                
                let result_tran = myDB.createTable("Trans", columnsInfo:[
                    "Time_Record TEXT NOT NULL UNIQUE",
                    "Barcode TEXT NOT NULL",
                    "Amount INTEGER NOT NULL",
                    "Price INTEGER NOT NULL",
                    "State INTEGER NOT NULL"
                    ])
                
                if result_tran {
                    myUserDefaults.set(1, forKey: "dbInit")
                    myUserDefaults.set(dbFileName, forKey: "dbFileName")
                    myUserDefaults.synchronize()
                }
                
                let result_species = myDB.createTable("Species", columnsInfo: [
                    "Category TEXT NOT NULL"
                    ])
                
                if result_species {
                    myUserDefaults.set(1, forKey: "dbInit")
                    myUserDefaults.set(dbFileName, forKey: "dbFileName")
                    myUserDefaults.synchronize()
                }
            }
            
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}


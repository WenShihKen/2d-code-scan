//
//  SQLiteTests.swift
//  app
//
//  Created by 張語航 on 2017/8/13.
//  Copyright © 2017年 apple. All rights reserved.
//

import XCTest
@testable import app

class SQLiteTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testinit() {
        let db = SQLiteConnect(file: "Tests.db")
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = urls[urls.count-1].absoluteString + "Tests.db"
        XCTAssertEqual(path,db?.dbPath)
    }
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

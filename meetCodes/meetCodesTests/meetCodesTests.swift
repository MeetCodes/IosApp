//
//  meetCodesTests.swift
//  meetCodesTests
//
//  Created by sweety prethish on 9/16/16.
//  Copyright © 2016 myrattles. All rights reserved.
//

import XCTest
@testable import meetCodes

class meetCodesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let timeNow = NSDate()
        let str = String(format: "%@ : This has failed now ", timeNow	)
        
        XCTFail(str)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

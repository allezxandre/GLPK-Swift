//
//  GLPKFramework_MacOSTests.swift
//  GLPKFramework_MacOSTests
//
//  Created by Alexandre Jouandin on 24/08/2017.
//

import XCTest
@testable import GLPKFramework_MacOS

class GLPKFramework_MacOSTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMain() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let problem = SwiftGLPK()
        problem.addCols(amount: 5)
    }
    
    func testBoundTypeFree() {
        let bound = BoundType.free
        XCTAssertEqual(nil, bound.lowerBound)
        XCTAssertEqual(nil, bound.upperBound)
    }
    
    func testBoundTypeFixed() {
        let bound = BoundType.fixed(value: 18.435)
        XCTAssertEqual(18.435, bound.lowerBound)
    }
    
    func testBoundTypeLower() {
        let bound = BoundType.lowerBoundOnly(value: 123.456)
        XCTAssertEqual(bound.lowerBound, 123.456)
        XCTAssertEqual(bound.upperBound, nil)
    }
    
    func testBoundTypeUpper() {
        let bound = BoundType.upperBoundOnly(value: 123.456)
        XCTAssertEqual(bound.lowerBound, nil)
        XCTAssertEqual(bound.upperBound, 123.456)
    }
    
    func testBoundTypeDouble() {
        let bound = BoundType.lowerAndUpperBound(lower: 123.456, upper: 789.1011)
        XCTAssertEqual(bound.lowerBound, 123.456)
        XCTAssertEqual(bound.upperBound, 789.1011)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

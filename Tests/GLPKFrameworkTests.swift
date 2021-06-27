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
    
    func testSampleFromDoc() {
        let problem = SwiftGLPK(name: "Sample", direction: .maximize)
        problem.disable32BitCastWarning = true
        problem.addRow(withName: "p", andBound: .upperBoundOnly(value: 100))
        problem.addRow(withName: "q", andBound: .upperBoundOnly(value: 600))
        problem.addRow(withName: "r", andBound: .upperBoundOnly(value: 300))
        problem.addColumn(withName: "x1", andBound: .lowerBoundOnly(value: 0), usingCoefficient: 10)
        problem.addColumn(withName: "x2", andBound: .lowerBoundOnly(value: 0), usingCoefficient:  6)
        problem.addColumn(withName: "x3", andBound: .lowerBoundOnly(value: 0), usingCoefficient:  4)
        problem.loadConstraintMatrix(valuesByRow: [
                [1, 1, 1],
                [10, 4, 5],
                [2, 2, 6]
            ])
        self.measure {
            problem.simplex()
        }
        let z = problem.functionValue
        XCTAssertEqual(z, 733.333, accuracy: 1e-3)
        
        
        // Check variables giving optimal solution
        // x1 = 33.3333; x2 = 66.6667; x3 = 0
        let x1 = problem.getSolutionVariable(i: 1)
        XCTAssertEqual(x1, 33.333, accuracy: 1e-3)
        let x2 = problem.getSolutionVariable(i: 2)
        XCTAssertEqual(x2, 66.666, accuracy: 1e-3)
        let x3 = problem.getSolutionVariable(i: 3)
        XCTAssertEqual(x3, 0.0, accuracy: 1e-3)
    }
    
    // Test factory example from
    // https://www.pmcalculators.com/example/simplex-method-problems/
    func testGutchiCompany() {
        let problem = SwiftGLPK(name: "The Gutchi Company", direction: .maximize)
        problem.disable32BitCastWarning = true
        problem.addRow(withName: "leather", andBound: .upperBoundOnly(value: 42))
        problem.addRow(withName: "sewing", andBound: .upperBoundOnly(value: 40))
        problem.addRow(withName: "finishing", andBound: .upperBoundOnly(value: 45))
        problem.addColumn(withName: "x1", andBound: .lowerBoundOnly(value: 0), usingCoefficient: 24)
        problem.addColumn(withName: "x2", andBound: .lowerBoundOnly(value: 0), usingCoefficient: 22)
        problem.addColumn(withName: "x3", andBound: .lowerBoundOnly(value: 0), usingCoefficient: 45)
        problem.loadConstraintMatrix(valuesByRow: [
                [2, 1, 3],
                [2, 1, 2],
                [1, 0.5, 1]
            ])
        self.measure {
            problem.simplex()
        }
        let z = problem.functionValue
        XCTAssertEqual(z, 882.000, accuracy: 1e-3)
        
        // Check variables giving optimal solution
        // x1=0, x2=36, x3=2
        let x1 = problem.getSolutionVariable(i: 1)
        XCTAssertEqual(x1, 0.00, accuracy: 1e-3)
        let x2 = problem.getSolutionVariable(i: 2)
        XCTAssertEqual(x2, 36.00, accuracy: 1e-3)
        let x3 = problem.getSolutionVariable(i: 3)
        XCTAssertEqual(x3, 2.00, accuracy: 1e-3)
    }
    
    
}

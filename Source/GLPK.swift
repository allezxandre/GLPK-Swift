//
//  glpk.swift
//  GLPKFramework_MacOS
//
//  Created by Alexandre Jouandin on 24/08/2017.
//

import Foundation
import glpk

public typealias Problem = glp_prob

public class SwiftGLPK {
    
    private var problemPointer: UnsafeMutablePointer<glp_prob>!
    public var problem: Problem {
        return self.problemPointer.pointee
    }
    
    public var disable32BitCastWarning = false
    
    public init() {
        self.problemPointer = glp_create_prob()
    }
    
    convenience init(name: String, direction: Direction? = nil) {
        self.init()
        glp_set_prob_name(self.problemPointer, name)
        if let direction = direction { self.direction = direction }
    }
    
    deinit {
        glp_delete_prob(problemPointer)
    }
    
    // MARK: - Basics
    // MARK: Problem creating and modifying
    
    /// Erases the content of the problem object.
    public func reset() {
        glp_erase_prob(problemPointer)
    }
    
    /// The optimization direction flag (i.e. “sense” of the objective function)
    /// - note: By default the problem is minimization.
    var direction: Direction {
        get {
            return Direction(fromIntegerValue: glp_get_obj_dir(self.problemPointer))
        }
        set(newDirection) {
            glp_set_obj_dir(self.problemPointer, newDirection.integerValue)
        }
    }
    
    /**
     Adds `amount` rows (constraints) to the problem object.
     New rows are always added to the end of the row list, so the ordinal numbers of existing rows are not changed.
     - parameter amount: The number of rows to add.
     
     - note: Being added each new row is initially free (unbounded) and has empty list of the constraint coeﬃcients.
     - note: Each new row becomes a non-active (non-binding) constraint, i.e. the corresponding auxiliary variable is marked as basic.
     - note: If the basis factorization exists, adding row(s) invalidates it.
     - returns: The ordinal number of the ﬁrst new row added to the problem object.
     */
    @discardableResult public func addRows(amount: Int32) -> Int {
        return Int(glp_add_rows(problemPointer, amount))
    }
    
    /**
     Adds `amount` rows (constraints) to the problem object.
     New rows are always added to the end of the row list, so the ordinal numbers of existing rows are not changed.
     - parameter amount: The number of rows to add.
     
     - important: The `amount` parameter will be cast to a 32bit integer.
     
     - note: Being added each new row is initially free (unbounded) and has empty list of the constraint coeﬃcients.
     - note: Each new row becomes a non-active (non-binding) constraint, i.e. the corresponding auxiliary variable is marked as basic.
     - note: If the basis factorization exists, adding row(s) invalidates it.
     - returns: The ordinal number of the ﬁrst new row added to the problem object.
     */
    @discardableResult public func addRows(amount: Int) -> Int {
        self.warnCast()
        return self.addRows(amount: Int32(amount))
    }
    
    /**
     Adds `amount` columns (structural variables) to the speciﬁed problem object.
     New columns are always added to the end of the column list, so the ordinal numbers of existing columns are not changed.
     - parameter amount: The number of columns to add.
     
     - note: Being added each new column is initially ﬁxed at zero and has empty list of the constraint coeﬃcients.
     - note: Each new column is marked as non-basic, i.e. zero value of the corresponding structural variable becomes an active (binding) bound.
     - note: If the basis factorization exists, it remains valid.
     - returns: The ordinal number of the ﬁrst new column added to the problem object.
     */
    @discardableResult public func addCols(amount: Int32) -> Int {
        return Int(glp_add_cols(problemPointer, amount))
    }
    
    /**
     Adds `amount` columns (structural variables) to the speciﬁed problem object.
     New columns are always added to the end of the column list, so the ordinal numbers of existing columns are not changed.
     - parameter amount: The number of columns to add.
     
     - important: The `amount` parameter will be cast to a 32bit integer.
     
     - note: Being added each new column is initially ﬁxed at zero and has empty list of the constraint coeﬃcients.
     - note: Each new column is marked as non-basic, i.e. zero value of the corresponding structural variable becomes an active (binding) bound.
     - note: If the basis factorization exists, it remains valid.
     - returns: The ordinal number of the ﬁrst new column added to the problem object.
     */
    @discardableResult public func addCols(amount: Int) -> Int {
        self.warnCast()
        return self.addCols(amount: Int32(amount))
    }
    
    /**
     Assigns a given symbolic name (1 up to 255 characters) to i-th row (auxiliary variable) of the problem object.
     
     - parameter name: The new name. If the parameter `name` is `nil` or empty string, the routine erases an existing name of i-th row.
     - parameter i: Index of the row to rename.
     */
    public func set(name: String?, forRow i: Int32) {
        glp_set_row_name(problemPointer, i, name ?? "")
    }
    
    /**
     Assigns a given symbolic name (1 up to 255 characters) to i-th row (auxiliary variable) of the problem object.
     
     - parameter name: The new name. If the parameter `name` is `nil` or empty string, the routine erases an existing name of i-th row.
     - parameter i: Index of the row to rename.
     
     - important: The row parameter will be cast to a 32bit integer.
     */
    public func set(name: String?, forRow i: Int) {
        warnCast()
        return self.set(name: name, forRow: Int32(i))
    }
    
    /**
     Assigns a given symbolic `name` (1 up to 255 characters) to j-th column (structural variable) of the speciﬁed problem object.
     
     - parameter name: The new name. If the parameter `name` is `nil` or empty string, the routine erases an existing name of j-th column.
     - parameter j: Index of the column to rename.
     */
    public func set(name: String?, forColumn j: Int32) {
        glp_set_row_name(problemPointer, j, name ?? "")
    }
    
    /**
     Assigns a given symbolic `name` (1 up to 255 characters) to j-th column (structural variable) of the speciﬁed problem object.
     
     - parameter name: The new name. If the parameter `name` is `nil` or empty string, the routine erases an existing name of j-th column.
     - parameter j: Index of the column to rename.
     
     - important: The column parameter will be cast to a 32bit integer.
     */
    public func set(name: String?, forColumn j: Int) {
        warnCast()
        self.set(name: name, forColumn: Int32(j))
    }
    
    /**
     Sets (changes) the type and bounds of i-th row (auxiliary variable) of the speciﬁed problem object.
     
     - parameter bound: The bound to use.
     - parameter i: The index of the row on which the bound will be applied.
     
     - note: Being added to the problem object each row is initially free.
     */
    public func set(bound: BoundType, forRow i: Int32) {
        glp_set_row_bnds(problemPointer, i, bound.typeValue, bound.lowerBound ?? 0, bound.upperBound ?? 0)
    }
    
    /**
     Sets (changes) the type and bounds of i-th row (auxiliary variable) of the speciﬁed problem object.
     
     - parameter bound: The bound to use.
     - parameter i: The index of the row on which the bound will be applied.
     
     - important: The row parameter will be cast to a 32bit integer.
     
     - note: Being added to the problem object each row is initially free.
     */
    public func set(bound: BoundType, forRow i: Int) {
        warnCast()
        self.set(bound: bound, forRow: Int32(i))
    }
    
    /**
     Sets (changes) the type and bounds of j-th column (structural variable) of the speciﬁed problem object.
     
     - parameter bound: The bound to use.
     - parameter j: The index of the column on which the bound will be applied.
     
     - note: Being added to the problem object each column is initially ﬁxed at zero.
     */
    public func set(bound: BoundType, forColumn j: Int32) {
        glp_set_col_bnds(problemPointer, j, bound.typeValue, bound.lowerBound ?? 0, bound.upperBound ?? 0)
    }
    
    /**
     Sets (changes) the type and bounds of j-th column (structural variable) of the speciﬁed problem object.
     
     - parameter bound: The bound to use.
     - parameter j: The index of the column on which the bound will be applied.
     
     - important: The column parameter will be cast to a 32bit integer.
     
     - note: Being added to the problem object each column is initially ﬁxed at zero.
     */
    public func set(bound: BoundType, forColumn j: Int) {
        warnCast()
        self.set(bound: bound, forColumn: Int32(j))
    }
    
    /**
     Sets (changes) the objective coefficient at j-th column (structural variable).
     
     - parameter coef: The new value of the objective coefficient.
     - parameter j: The index of the column on which the coefficient will be applied.
                    If the parameter is 0, the routine sets (changes) the constant term (“shift”) of the objective function.
     */
    public func set(coef: Double, forColumn j: Int32) {
        glp_set_obj_coef(problemPointer, j, coef)
    }
    
    /**
     Sets (changes) the objective coefficient at j-th column (structural variable).
     
     - parameter coef: The new value of the objective coefficient.
     - parameter j: The index of the column on which the coefficient will be applied.
     If the parameter is 0, the routine sets (changes) the constant term (“shift”) of the objective function.
     
     - important: The column parameter will be cast to a 32bit integer.
     */
    public func set(coef: Double, forColumn j: Int) {
        warnCast()
        self.set(coef: coef, forColumn: j)
    }
    
    public func loadConstraintMatrix(rowIndices: [Int32], columnIndices: [Int32], values: [Double]) {
        let n = Int32(values.count)
        assert(rowIndices.count == n,
               "Unexpected number of row indices. Expected \(n) indices but only \(rowIndices.count) were specified.")
        assert(columnIndices.count == n,
               "Unexpected number of column indices. Expected \(n) indices but only \(columnIndices.count) were specified.")
        let rowIndices = [0] + rowIndices // Because indices start at 1
        let columnIndices = [0] + columnIndices
        let values = [0] + values
        glp_load_matrix(problemPointer, n, rowIndices, columnIndices, values)
    }
    
    // MARK: Shorthand
    /**
     Add a new row (auxiliary variable) to the current problem.
     
     - parameter name: An optional name to use for the variable.
     - parameter bound: The bounds to apply to the variable.
     
     - returns: The `i` index of the new row.
     */
    @discardableResult public func addRow(withName name: String?, andBound bound: BoundType) -> Int {
        let rowIndex = self.addRows(amount: Int32(1))
        self.set(name: name, forRow: Int32(rowIndex))
        self.set(bound: bound, forRow: Int32(rowIndex))
        return rowIndex
    }
    
    /**
     Add a new column (structural variable) to the current problem.
     
     - parameter name: An optional name to use for the variable.
     - parameter bound: The bounds to apply to the variable.
     - parameter coef: An optional coefficient to apply to the variable in the objective function.
     
     - returns: The `j` index of the new column.
     */
    @discardableResult public func addColumn(withName name: String?, andBound bound: BoundType, usingCoefficient coef: Double? = nil) -> Int {
        let columnIndex = self.addCols(amount: Int32(1))
        self.set(name: name, forColumn: Int32(columnIndex))
        self.set(bound: bound, forColumn: Int32(columnIndex))
        if let coef = coef { self.set(coef: coef, forColumn: Int32(columnIndex)) }
        return columnIndex
    }
    
    /**
     Load a matrix by giving its values ordered by row.
     
     To represent the following example matrix:
     ````
     1 2
     3 4
     5 6
     ````
     use the following argument for `matrix`:
     ````
     [[1, 2], [3, 4], [5, 6]]
     ````
     
     - parameter matrix: An array of an array of the values to use.
     */
    public func loadConstraintMatrix(valuesByRow matrix: [[Double]]) {
        var rows = [Int32]()
        var columns = [Int32]()
        var values = [Double]()
        var i: Int32 = 1
        for row in matrix {
            var j: Int32 = 1
            for value in row {
                rows.append(i)
                columns.append(j)
                values.append(value)
                j += 1
            }
            i += 1
        }
        self.loadConstraintMatrix(rowIndices: rows, columnIndices: columns, values: values)
    }
    
    /// Retrieves problem data from the specified problem object, calls the solver to solve the problem instance, and stores results of computations back into the problem object.
    /// - ToDo: Implement simplex arguments in Swift.
    public func simplex() {
        glp_simplex(problemPointer, nil)
    }
    
    
    /// Returns the current value of the objective function.
    var functionValue: Double {
        return glp_get_obj_val(problemPointer)
    }

    /// Returns the solution variable for given index
    public func getSolutionVariable(atIndex i: Int32) -> Double {
        return glp_get_col_prim(problemPointer, i)
    }
    
    // MARK: - Utilities
    func warn(message: String, function: StaticString = #function) {
        print("\n/!\\ Warning (from function `\(function)`):\n\t\(message)\n")
    }
    
    func warnCast(function: StaticString = #function) {
        if !disable32BitCastWarning
            { warn(message: "casting integer to 32 bytes", function: function) }
    }
}

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
    
    convenience init(name: String) {
        self.init()
        glp_set_prob_name(self.problemPointer, name)
    }
    
    // MARK: - Basics
    // MARK: Problem creating and modifying
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
    
    // MARK: - Utilities
    func warn(message: String, function: StaticString = #function) {
        print("\n/!\\ Warning (from function `\(function)`):\n\t\(message)\n")
    }
    
    func warnCast(function: StaticString = #function) {
        if !disable32BitCastWarning
            { warn(message: "casting integer to 32 bytes", function: function) }
    }
}

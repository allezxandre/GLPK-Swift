//
//  BoundType.swift
//  GLPKFramework
//
//  Created by Alexandre Jouandin on 25/08/2017.
//

import Foundation
import glpk

/**
 Specification for the bounds of a variable.
 */
public enum BoundType {
    case free, fixed(value: Double),
    lowerBoundOnly(value: Double), upperBoundOnly(value: Double),
    lowerAndUpperBound(lower: Double, upper: Double)
    
    /// The internal C-Int32 global variable that represents the bound type
    var typeValue: Int32 {
        switch self {
        case .free:
            return GLP_FR
        case .fixed(_):
            return GLP_FX
        case .lowerBoundOnly(_):
            return GLP_LO
        case .upperBoundOnly(_):
            return GLP_UP
        case .lowerAndUpperBound(_,_):
            return GLP_DB
        }
    }
    
    /// The lower bound of this bound type, or nil if there isn't any.
    var lowerBound: Double? {
        switch self {
        case .free, .upperBoundOnly(_):
            return nil
        case .fixed(let value), .lowerBoundOnly(let value):
            return value
        case .lowerAndUpperBound(let lower,_):
            return lower
        }
    }
    
    /// The upper bound of this bound type, or nil if there isn't any.
    var upperBound: Double? {
        switch self {
        case .free, .lowerBoundOnly(_):
            return nil
        case .fixed(let value), .upperBoundOnly(let value):
            return value
        case .lowerAndUpperBound(_, let upper):
            return upper
        }
    }
}

//
//  Direction.swift
//  GLPKFramework
//
//  Created by Alexandre Jouandin on 25/08/2017.
//

import Foundation
import glpk

public enum Direction {
    case minimize, maximize
    
    init(fromIntegerValue integer: Int32) {
        switch integer {
        case GLP_MIN:
            self = .minimize
            break
        case GLP_MAX:
            self = .maximize
            break
        default:
            assertionFailure("Unexpected integer value for direction: \(integer)")
            // Return minimize by default
            self = .minimize
            break
        }
    }
    
    var integerValue: Int32 {
        switch self {
        case .minimize:
            return GLP_MIN
        case .maximize:
            return GLP_MAX
        }
    }
}

//
//  glpk.swift
//  GLPKFramework_MacOS
//
//  Created by Alexandre Jouandin on 24/08/2017.
//

import Foundation
import glpk

typealias Problem = glp_prob

public class SwiftGLPK {
    
    private var problemPointer: UnsafeMutablePointer<glp_prob>!
    var problem: Problem {
        return self.problemPointer.pointee
    }
    
    init() {
        self.problemPointer = glp_create_prob()
    }
    
    convenience init(name: String) {
        self.init()
        glp_set_prob_name(self.problemPointer, name)
    }
}

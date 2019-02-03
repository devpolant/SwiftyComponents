//
//  Weakable.swift
//  Components
//
//  Created by Anton Poltoratskyi on 24.08.2018.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

protocol Weakable: class {}

extension Weakable {
    typealias Func = Self
    
    typealias Closure<Arguments> = (Arguments) -> Void
    
    func weak<Arguments>(_ method: @escaping (Func) -> Closure<Arguments>) -> Closure<Arguments> {
        return { [weak self] args in
            guard let `self` = self else {
                return
            }
            method(self)(args)
        }
    }
}

//
//  ErrorHandling.swift
//  Components
//
//  Created by Anton Poltoratskyi on 30.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

func notImplemented(function: String = #function, file: String = #file, line: Int = #line) -> Never {
    fatalError("\(function) not implemented")
}

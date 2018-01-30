//
//  ErrorHandling.swift
//  LikulatorInst
//
//  Created by Anton Poltoratskyi on 11/22/17.
//  Copyright © 2017 Appus Studio LP. All rights reserved.
//

import Foundation

func notImplemented(function: String = #function, file: String = #file, line: Int = #line) -> Never {
    fatalError("\(function) not implemented")
}

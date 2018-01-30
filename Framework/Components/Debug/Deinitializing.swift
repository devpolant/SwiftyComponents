//
//  Deinitializing.swift
//  Components
//
//  Created by Anton Poltoratskyi on 30.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

func deinited(_ object: AnyObject) {
    #if DEBUG
        debugPrint("\(type(of: object)) deinited")
    #endif
}

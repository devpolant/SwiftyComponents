//
//  Deinitializing.swift
//  LikulatorInst
//
//  Created by Anton Poltoratskyi on 12/1/17.
//  Copyright © 2017 Appus Studio LP. All rights reserved.
//

import Foundation

func deinited(_ object: AnyObject) {
    #if DEBUG
        debugPrint("\(type(of: object)) deinited")
    #endif
}

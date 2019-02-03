//
//  Reusable.swift
//  Components
//
//  Created by Anton Poltoratskyi on 27.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

public protocol Reusable {
    static var uniqueIdentifier: String { get }
}

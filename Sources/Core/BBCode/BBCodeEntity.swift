//
//  BBCodeEntity.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

protocol BBCodeEntity {
    static var tag: String { get }
    static var attributes: [String] { get }
}

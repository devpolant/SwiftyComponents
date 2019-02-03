//
//  URLRequestConvertible.swift
//  Components
//
//  Created by Anton Poltoratskyi on 29.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

public protocol URLRequestConvertible {
    func asURLRequest() -> URLRequest
}

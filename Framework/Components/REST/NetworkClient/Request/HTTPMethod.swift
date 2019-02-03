//
//  HTTPMethod.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get        = "GET"
    case head       = "HEAD"
    case post       = "POST"
    case put        = "PUT"
    case options    = "OPTIONS"
    case patch      = "PATCH"
    case delete     = "DELETE"
    case trace      = "TRACE"
    case connect    = "CONNECT"
}

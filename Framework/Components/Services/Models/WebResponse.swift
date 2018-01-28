//
//  WebResponse.swift
//  Components
//
//  Created by Anton Poltoratskyi on 29.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

protocol WebResponseProtocol {
    associatedtype ResponseData: Decodable
    
    var status: Bool { get }
    var error: String? { get }
    var data: ResponseData? { get }
}

struct WebResponse<T: Decodable>: Decodable, WebResponseProtocol {
    typealias ResponseData = T
    
    var status: Bool
    var error: String?
    var data: T?
}

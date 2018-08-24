//
//  WebResponse.swift
//  Components
//
//  Created by Anton Poltoratskyi on 29.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

public protocol ResponseRepresentable {
    associatedtype ResponseData: Decodable
    
    var status: Bool { get }
    var error: String? { get }
    var data: ResponseData? { get }
}

public struct WebResponse<T: Decodable>: Decodable, ResponseRepresentable {
    public typealias ResponseData = T
    
    public var status: Bool
    public var error: String?
    public var data: T?
}

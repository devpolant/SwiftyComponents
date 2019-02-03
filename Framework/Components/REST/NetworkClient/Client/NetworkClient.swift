//
//  NetworkClient.swift
//  Components
//
//  Created by Anton Poltoratskyi on 29.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

public protocol NetworkClient: class {
    @discardableResult
    func request<T: Decodable>(to target: URLRequestConvertible, completion: ((ResponseResult<T>) -> Void)?)  -> URLSessionTask
    
    @discardableResult
    func request<T: Decodable>(to target: URLRequestConvertible, decoder: JSONDecoder, completion: ((ResponseResult<T>) -> Void)?)  -> URLSessionTask
}

extension NetworkClient {
    
    @discardableResult
    public func request<T: Decodable>(to target: URLRequestConvertible, completion: ((ResponseResult<T>) -> Void)?)  -> URLSessionTask {
        let defaultDecoder = JSONDecoder()
        return request(to: target, decoder: defaultDecoder, completion: completion)
    }
}

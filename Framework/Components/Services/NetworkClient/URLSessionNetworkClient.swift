//
//  URLSessionNetworkClient.swift
//  Components
//
//  Created by Anton Poltoratskyi on 29.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

public final class URLSessionNetworkClient: NetworkClient {
    
    public var session = URLSession.shared
    
    @discardableResult
    public func request<T: Decodable>(to target: URLRequestConvertible, completion: ((ResponseResult<T>) -> Void)?)  -> URLSessionTask {
        let defaultDecoder = JSONDecoder()
        return request(to: target, decoder: defaultDecoder, completion: completion)
    }
    
    @discardableResult
    public func request<T: Decodable>(to target: URLRequestConvertible,
                                      decoder: JSONDecoder,
                                      completion: ((ResponseResult<T>) -> Void)?) -> URLSessionTask {
        let urlRequest = target.asURLRequest()
        let task = session.dataTask(with: urlRequest) { data, urlResponse, error in
            if let error = error {
                completion?(.failure(error))
            } else if let data = data {
                do {
                    let decodedData = try decoder.decode(T.self, from: data)
                    completion?(.success(decodedData))
                } catch {
                    completion?(.failure(APIError.jsonDecodingError(error)))
                }
            }
        }
        task.resume()
        
        return task
    }
}

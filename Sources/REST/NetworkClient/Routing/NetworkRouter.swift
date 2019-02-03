//
//  NetworkRouter.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

protocol NetworkRouter: URLRequestConvertible {
    static var scheme: String { get }
    static var host: String { get }
    static var port: Int? { get }

    var path: String { get }
    var method: HTTPMethod { get }
    var params: HTTPParameters? { get }
    var headers: HTTPHeaders { get }
    var queryItems: HTTPQueryItems? { get }
}

enum NetworkRouterError: Error {
    case invalidURL
}

extension NetworkRouter {

    var queryItems: HTTPParameters {
        return [:]
    }

    var params: HTTPParameters {
        return [:]
    }
    
    var headers: HTTPHeaders {
        return [:]
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try fullURL()

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try params.map { try JSONSerialization.data(withJSONObject: $0) }
        request.httpMethod = method.rawValue

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }

    private func fullURL() throws -> URL {

        var urlComponents = URLComponents()
        urlComponents.scheme = type(of: self).scheme
        urlComponents.host = type(of: self).host
        urlComponents.port = type(of: self).port
        urlComponents.path = path
        urlComponents.queryItems = queryItems?.map { URLQueryItem(name: $0, value: $1) }
        guard let url = urlComponents.url else {
            throw NetworkRouterError.invalidURL
        }
        return url
    }
}

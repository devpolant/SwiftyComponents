//
//  ResponseResult.swift
//  Components
//
//  Created by Anton Poltoratskyi on 29.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

enum ResponseResult<T> {
    case success(T)
    case failure(Error)
}

// MARK: - Parsing

// MARK: Single Entity

extension ResponseResult where T: WebResponseProtocol {
    
    typealias ResultType = T.ResponseData
    
    func process() -> ResponseResult<ResultType> {
        switch self {
        case let .success(response):
            if response.status, let data = response.data {
                return .success(data)
            }
            return processing(errorMessage: response.error)
        case let .failure(error):
            return processing(error: error)
        }
    }
}

// MARK: Collections

protocol JsonArray: RandomAccessCollection { }
extension Array: JsonArray { }

extension ResponseResult where T: WebResponseProtocol, T.ResponseData: JsonArray {
    
    typealias ResultCollection = [T.ResponseData.Element]
    
    func processCollection() -> ResponseResult<ResultCollection> {
        switch self {
        case let .success(response):
            if response.status, let data = response.data {
                return .success(data.map { $0 })
            }
            return processing(errorMessage: response.error)
        case let .failure(error):
            return processing(error: error)
        }
    }
}

// MARK: - Error Handling

extension ResponseResult {
    
    fileprivate func processing<ResultType>(errorMessage: String?) -> ResponseResult<ResultType> {
        return .failure(APIError.unknownError)
    }
    
    fileprivate func processing<ResultType>(error: Error) -> ResponseResult<ResultType> {
        return .failure(APIError.unknownError)
    }
}
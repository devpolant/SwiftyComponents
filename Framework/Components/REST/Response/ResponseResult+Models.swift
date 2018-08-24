//
//  ResponseResult+Models.swift
//  Components
//
//  Created by Anton Poltoratskyi on 30.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

public extension ResponseResult where T: ResponseRepresentable {
    
    public typealias ResultType = T.ResponseData
    
    public func process() -> ResponseResult<ResultType> {
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

// MARK: - Error Handling

extension ResponseResult {
    
    fileprivate func processing<ResultType>(errorMessage: String?) -> ResponseResult<ResultType> {
        return .failure(APIError.unknownError)
    }
    
    fileprivate func processing<ResultType>(error: Error) -> ResponseResult<ResultType> {
        return .failure(APIError.unknownError)
    }
}

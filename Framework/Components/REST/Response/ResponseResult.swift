//
//  ResponseResult.swift
//  Components
//
//  Created by Anton Poltoratskyi on 29.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

public enum ResponseResult<T> {
    case success(T)
    case failure(Error)
}

extension ResponseResult {
    public func flatMap<NextValue>(transform: (T) -> ResponseResult<NextValue>) -> ResponseResult<NextValue> {
        switch self {
        case let .success(value):
            return transform(value)
        case let .failure(error):
            return .failure(error)
        }
    }
}

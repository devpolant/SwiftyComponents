//
//  BBTagBuilder.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

final class BBTagBuilder {
    
    struct Attribute {
        var name: String
        var value: String
    }
    
    static func build(tag: String, attributes: [Attribute], content: String?) -> String {
        let attributes = attributes.reduce(into: "") {
            let value = "\($1.name)=\"\($1.value)\""
            $0.append($0.isEmpty ? value : " \(value)")
        }
        return "[\(tag) \(attributes)]\(content ?? "")[/\(tag)]"
    }
}

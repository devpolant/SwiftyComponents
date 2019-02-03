//
//  BBCodeParser.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

final class BBCodeParser {
    
    static func findOccurences<T: BBCodeEntity>(of entity: T.Type, in text: String, transform: (BBCodeElement) -> T?) -> [T]? {
        let parseResult = findOccurrences(of: T.tag, expectedAttributes: T.attributes, in: text)
        
        guard let tags = parseResult, !tags.isEmpty else {
            return nil
        }
        return tags.compactMap(transform)
    }
    
    static func findOccurrences(of tag: String, expectedAttributes: [String], in text: String) -> [BBCodeElement]? {
        guard !text.isEmpty else {
            return nil
        }
        var searchRange: Range<String.Index> = text.startIndex..<text.endIndex
        var result: [BBCodeElement] = []
        
        while let tagStartRange = text.range(of: "[\(tag)", range: searchRange),
            case let nextSearchRange1 = tagStartRange.upperBound..<text.endIndex,
            let tagEndRange = text.range(of: "]", range: nextSearchRange1),
            case let nextSearchRange2 = tagEndRange.upperBound..<text.endIndex,
            let tagCloseRange = text.range(of: "[/\(tag)]", range: nextSearchRange2),
            case let nextSearchRange3 = tagCloseRange.upperBound..<text.endIndex
        {
            defer { searchRange = nextSearchRange3 }
            
            let startIndex = tagStartRange.lowerBound
            let endIndex = tagCloseRange.upperBound
            
            // Find attributes
            var attributes: [String: String] = [:]
            
            let tagRange: Range<String.Index> = tagStartRange.upperBound..<tagEndRange.upperBound
            
            for expectedAttribute in expectedAttributes {
                guard let attributeRange = text.range(of: "\(expectedAttribute)=\"", range: tagRange) else {
                    continue
                }
                let valueRange = attributeRange.upperBound..<tagRange.upperBound
                guard let valueEndRange = text.range(of: "\"", range: valueRange) else {
                    continue
                }
                let value = text[attributeRange.upperBound..<valueEndRange.lowerBound]
                attributes[expectedAttribute] = String(value)
            }
            
            // Find text between [tag ...] and [\tag]
            let contentText = text[tagEndRange.upperBound..<tagCloseRange.lowerBound]
            
            let element = BBCodeElement(tag: tag, indices: startIndex..<endIndex, text: String(contentText), attributes: attributes)
            result.append(element)
        }
        
        return result
    }
}

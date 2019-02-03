//
//  RangeExtension.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2019 Anton Poltoratskyi. All rights reserved.
//

import Foundation

// MARK: - String.Index

extension Range where Bound == String.Index {
    var utf16Encoded: Range<Int> {
        return lowerBound.encodedOffset..<upperBound.encodedOffset
    }
}

extension Range where Bound == Int {
    var stringIndices: Range<String.Index> {
        return String.Index(encodedOffset: lowerBound)..<String.Index(encodedOffset: upperBound)
    }
}

// MARK: - NSRange

extension Range where Bound == Int {
    
    init(_ range: NSRange) {
        self = range.lowerBound..<range.upperBound
    }
    
    var nsRange: NSRange {
        return NSRange(location: lowerBound, length: count)
    }
}

extension NSRange {
    
    var nativeRange: Range<Int> {
        return Range(self)
    }
}

// MARK: - Shift

extension Range where Bound == Int {
    mutating func shift(by offset: Bound) {
        self = lowerBound.advanced(by: offset)..<upperBound.advanced(by: offset)
    }
    
    func shifted(by offset: Bound) -> Range<Bound> {
        return lowerBound.advanced(by: offset)..<upperBound.advanced(by: offset)
    }
    
    func shiftedLowerBound(by offset: Bound) -> Range<Bound> {
        return lowerBound.advanced(by: offset)..<upperBound
    }
}

// MARK: - Alongside

extension Range where Bound == Int {
    func isAlongside(after range: Range<Bound>) -> Bool {
        return range.upperBound == lowerBound
    }
    
    func isAlongside(after range: ClosedRange<Bound>) -> Bool {
        return range.upperBound == lowerBound - 1
    }
    
    func isAlongside(before range: Range<Bound>) -> Bool {
        return upperBound == range.lowerBound
    }
    
    func isAlongside(before range: ClosedRange<Bound>) -> Bool {
        return upperBound == range.lowerBound
    }
}

// MARK: - Intersection

extension Range where Bound == Int {
    
    func intersects(_ range: Range<Bound>) -> Bool {
        return contains(range.lowerBound)
            || contains(range.upperBound - 1)
            || range.contains(lowerBound)
            || range.contains(upperBound - 1)
    }
    
    func intersects(_ range: ClosedRange<Bound>) -> Bool {
        return contains(range.lowerBound)
            || contains(range.upperBound)
            || range.contains(lowerBound)
            || range.contains(upperBound - 1)
    }
}

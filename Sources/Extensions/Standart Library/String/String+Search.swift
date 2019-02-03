//
//  String+Search.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

extension String {
    func isIn(string: String, options: String.CompareOptions) -> Bool {
        return string.contains(substring: self, options: options)
    }
    
    func isIn(strings: [String], options: String.CompareOptions) -> Bool {
        return strings.contains(substring: self, options: options)
    }
    
    func contains(substring: String, options: String.CompareOptions) -> Bool {
        return range(of: substring, options: options) != nil
    }
    
    func starts(with possiblePrefix: String, options: String.CompareOptions) -> Bool {
        guard !possiblePrefix.isEmpty else {
            return true
        }
        guard let range = self.range(of: possiblePrefix, options: options) else {
            return false
        }
        return range.lowerBound == startIndex
    }
}

extension String {
    func ends(with possibleSuffix: String) -> Bool {
        return reversed().starts(with: possibleSuffix.reversed())
    }
}

extension Array where Element == String {
    func contains(substring: String, options: String.CompareOptions) -> Bool {
        return contains { $0.contains(substring: substring, options: options) }
    }
}

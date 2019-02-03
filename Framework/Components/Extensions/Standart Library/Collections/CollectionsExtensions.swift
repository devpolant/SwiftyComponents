//
//  CollectionsExtensions.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Collection where Element: Hashable {

    func uniqueWithPreservedOrder() -> [Element] {
        var set = Set(self)
        return filter {
            let result = set.contains($0)
            set.remove($0)
            return result
        }
    }
}

extension Collection where Index == Int {
    
    func first(_ n: Int) -> SubSequence {
        return count >= n
            ? self[startIndex..<startIndex + n]
            : self[startIndex..<startIndex + count]
    }
}

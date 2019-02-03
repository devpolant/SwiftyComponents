//
//  BidirectionalCollection.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

extension BidirectionalCollection {
    
    func lastIndex(where predicate: (Iterator.Element) -> Bool) -> Index? {
        guard !isEmpty else {
            return nil
        }
        var result: Index?
        
        var currentIndex = endIndex
        
        while currentIndex != startIndex {
            let index = self.index(before: currentIndex)
            let element = self[index]
            
            guard !predicate(element) else {
                result = index
                break
            }
            currentIndex = index
        }
        
        return result
    }
    
    func last(where predicate: (Iterator.Element) -> Bool) -> Iterator.Element? {
        return lastIndex(where: predicate).flatMap { self[$0] }
    }
}

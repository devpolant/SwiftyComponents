//
//  TextInputUtils.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

public enum TextInputUtils {
    
    public static func updatedCursor(for replacementText: String, in replacementRange: NSRange, currentText text: String) -> Int {
        let newCursorPosition: Int
        if replacementRange.length > replacementText.utf16.count {
            // delete or replace
            newCursorPosition = replacementRange.upperBound - (replacementRange.length - replacementText.utf16.count)
        } else {
            // insert
            newCursorPosition = replacementRange.upperBound + (replacementText.utf16.count - replacementRange.length)
        }
        
        return newCursorPosition
    }
}

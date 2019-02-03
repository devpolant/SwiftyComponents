//
//  UITextInput.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit

extension UITextInput {
    
    public var cursorPosition: Int? {
        get {
            guard let selectedRange = selectedTextRange else {
                return nil
            }
            return offset(from: beginningOfDocument, to: selectedRange.start)
        }
        set {
            if let newValue = newValue {
                if let newPosition = position(from: beginningOfDocument, offset: newValue) {
                    selectedTextRange = textRange(from: newPosition, to: newPosition)
                }
            } else {
                selectedTextRange = nil
            }
        }
    }
    
    public func moveCursorToStart() {
        cursorPosition = 0
    }
    
    public func moveCursorToEnd() {
        guard let range = textRange(from: beginningOfDocument, to: endOfDocument), let text = self.text(in: range) else {
            cursorPosition = 0
            return
        }
        cursorPosition = text.isEmpty ? 0 : text.endIndex.encodedOffset
    }
}

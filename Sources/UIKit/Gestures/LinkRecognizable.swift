//
//  LinkRecognizable.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit

public protocol LinkRecognizable: class {
    associatedtype Link
    
    var textView: UITextView { get }
    var targetAttribute: NSAttributedString.Key { get }
    
    var selection: (Link, NSRange)? { get set }
    var handler: ((Link, NSRange) -> Void)? { get set }
    
    init(textView: UITextView, targetAttribute: NSAttributedString.Key)
    
    func handleTouch(on location: CGPoint) -> (Link, NSRange)?
    func resetSelection()
}

extension LinkRecognizable {
    
    public func handleTouch(on location: CGPoint) -> (Link, NSRange)? {
        var textPos1: UITextPosition?
        var textPos2: UITextPosition?
        
        textPos1 = textView.closestPosition(to: location)
        textPos2 = textPos1.flatMap { textView.position(from: $0, offset: 1) }
        
        if textPos2 == nil {
            if let position = textPos1 {
                textPos1 = textView.position(from: position, offset: -1)
            }
            if let position = textPos1 {
                textPos2 = textView.position(from: position, offset: 1)
            }
        }
        
        guard textPos1 != nil && textPos2 != nil else {
            return nil
        }
        guard let range = textView.textRange(from: textPos1!, to: textPos2!) else {
            return nil
        }
        
        let startOffset = textView.offset(from: textView.beginningOfDocument, to: range.start)
        let endOffset = textView.offset(from: textView.beginningOfDocument, to: range.end)
        let offsetRange = NSMakeRange(startOffset, endOffset - startOffset)
        
        guard offsetRange.location != NSNotFound && offsetRange.length != 0 else {
            return nil
        }
        guard NSMaxRange(offsetRange) <= textView.attributedText.length else {
            return nil
        }
        
        let attrString = textView.attributedText.attributedSubstring(from: offsetRange)
        
        guard let target = attrString.attribute(targetAttribute, at: 0, effectiveRange: nil) as? Link else {
            return nil
        }
        return (target, offsetRange)
    }
    
    public func resetSelection() {
        selection = nil
    }
}

//
//  LinkLongPressGestureRecognizer.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit

public final class LinkLongPressGestureRecognizer<Link>: UILongPressGestureRecognizer, UIGestureRecognizerDelegate, LinkRecognizable {

    public unowned let textView: UITextView
    public let targetAttribute: NSAttributedString.Key
    
    public var selection: (Link, NSRange)?
    public var handler: ((Link, NSRange) -> Void)?
    
    
    // MARK: - Init
    
    public init(textView: UITextView, targetAttribute: NSAttributedString.Key) {
        self.textView = textView
        self.targetAttribute = targetAttribute
        super.init(target: nil, action: nil)
        addTarget(self, action: #selector(handleLongPress(recognizer:)))
        delegate = self
    }
    
    
    // MARK: - Long Press
    
    @objc private func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        defer { selection = nil }
        guard case .began = recognizer.state else {
            return
        }
        selection.map { handler?($0.0, $0.1) }
    }
    
    
    // MARK: - UIGestureRecognizerDelegate
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: textView)
        guard let value = handleTouch(on: location) else {
            return false
        }
        self.selection = value
        return true
    }
}

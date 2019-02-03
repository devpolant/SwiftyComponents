//
//  ClosureGestureRecognizer.swift
//  Components
//
//  Created by Anton Poltoratskyi on 24.08.2018.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit

public final class ClosureGestureRecognizer<Recognizer: UIGestureRecognizer> {
    
    public var action: ((Recognizer) -> Void)?
    public var recogizer: Recognizer
    
    public init(action: ((Recognizer) -> Void)? = nil) {
        self.action = action
        self.recogizer = Recognizer(target: nil, action: nil)
        self.recogizer.addTarget(self, action: #selector(eventRecognized(recognizer:)))
    }
    
    @objc private func eventRecognized(recognizer: UIGestureRecognizer) {
        guard let recognizer = recognizer as? Recognizer else {
            return
        }
        action?(recognizer)
    }
}

extension UIView {
    
    func addGestureRecognizer<R: UIGestureRecognizer>(_ closureRecognizer: ClosureGestureRecognizer<R>) {
        addGestureRecognizer(closureRecognizer.recogizer)
    }
}

//
//  LongPressClosureRecognizer.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

final class LongPressClosureRecognizer: UILongPressGestureRecognizer {
    
    private let handler: (UILongPressGestureRecognizer) -> Void
    
    init(handler: @escaping (UILongPressGestureRecognizer) -> Void) {
        self.handler = handler
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(handleGesture(recognizer:)))
    }
    
    @objc private func handleGesture(recognizer: UILongPressGestureRecognizer) {
        handler(recognizer)
    }
}

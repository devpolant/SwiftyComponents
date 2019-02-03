//
//  UnidirectionalPanGestureRecognizer.swift
//  Components
//
//  Created by Anton Poltoratskyi on 24.08.2018.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

class UnidirectionalPanGestureRecognizer: UIPanGestureRecognizer {
    
    private var originalLocation: CGPoint = .zero
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        originalLocation = touches.first!.location(in: view?.superview)
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if case .possible = state {
            let currentLocation = touches.first!.location(in: view?.superview)
            let dx = abs(currentLocation.x - originalLocation.x)
            let dy = abs(currentLocation.y - originalLocation.y)
            if shouldFail(dx: dx, dy: dy) {
                state = .failed
            }
        }
        super.touchesMoved(touches, with: event)
    }
    
    override func translation(in view: UIView?) -> CGPoint {
        var translation = super.translation(in: view)
        modifyTranslation(&translation)
        return translation
    }
    
    func shouldFail(dx: CGFloat, dy: CGFloat) -> Bool {
        // implemented in subclasses
        return false
    }
    
    func modifyTranslation(_ translation: inout CGPoint) {
        // implemented in subclasses
    }
}

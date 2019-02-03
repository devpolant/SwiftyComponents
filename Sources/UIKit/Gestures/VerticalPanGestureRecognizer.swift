//
//  VerticalPanGestureRecognizer.swift
//  Components
//
//  Created by Anton Poltoratskyi on 24.08.2018.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

final class VerticalPanGestureRecognizer: UnidirectionalPanGestureRecognizer {
    
    override func shouldFail(dx: CGFloat, dy: CGFloat) -> Bool {
        return dx > dy
    }
    
    override func modifyTranslation(_ translation: inout CGPoint) {
        translation.x = 0
    }
}

//
//  UIScreen+Keyboard.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit

extension UIScreen {
    
    var defaultKeyboardHeight: CGFloat {
        let height = bounds.height
        if height >= 812 {
            return 333
        } else if height >= 736 {
            return 271
        } else if height >= 667 {
            return 258
        } else {
            return 253
        }
    }
    
    var defaultKeyboardSize: CGSize {
        return CGSize(width: bounds.width, height: defaultKeyboardHeight)
    }
}

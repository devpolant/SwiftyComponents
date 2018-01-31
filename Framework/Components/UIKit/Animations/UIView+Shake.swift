//
//  UIView+Shake.swift
//  Components
//
//  Created by Anton Poltoratskyi on 31.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit

extension UIView {
    func shake() {
        let shake = CAKeyframeAnimation(keyPath: "transform")
        shake.values = [
            NSValue(caTransform3D: CATransform3DMakeTranslation(-6.0, 0.0, 0.0)),
            NSValue(caTransform3D: CATransform3DMakeTranslation(6.0, 0.0, 0.0))
        ]
        shake.duration = 0.07
        shake.repeatCount = 2.0
        shake.autoreverses = true
        self.layer.add(shake, forKey: "shake")
    }
}

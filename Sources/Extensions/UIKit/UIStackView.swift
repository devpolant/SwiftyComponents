//
//  UIStackView.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit

extension UIStackView {
    
    public func remove(_ subview: UIView) {
        removeArrangedSubview(subview)
        subview.removeFromSuperview()
    }
    
    public func removeArrangedSubviews() {
        arrangedSubviews.forEach { remove($0) }
    }
}

//
//  NSAttributedString+Bounds.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

extension NSAttributedString {
    
    func size(constrainedBy maxWidth: CGFloat, options: NSStringDrawingOptions = .usesLineFragmentOrigin) -> CGSize {
        let maxSize = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let rect = self.boundingRect(with: maxSize, options: options, context: nil)
        return CGSize(width: ceil(rect.width), height: ceil(rect.height))
    }
}

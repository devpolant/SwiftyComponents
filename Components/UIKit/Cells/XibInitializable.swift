//
//  XibInitializable.swift
//  Components
//
//  Created by Anton Poltoratskyi on 27.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation
import UIKit

protocol XibInitializable: class {
    static var xibFileName: String { get }
}


extension XibInitializable where Self: UIView {
    static var xibFileName: String {
        return String(describing: type(of: self))
    }
}

extension XibInitializable where Self: UIViewController {
    static var xibFileName: String {
        return String(describing: type(of: self))
    }
    static func instantiateFromXib() -> Self {
        return Self(nibName: xibFileName, bundle: nil)
    }
}

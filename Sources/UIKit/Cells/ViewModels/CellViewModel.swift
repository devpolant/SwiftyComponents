//
//  Cell+ViewModel.swift
//  Components
//
//  Created by Anton Poltoratskyi on 27.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation
import UIKit

public typealias ReusableView = UIView & Reusable

public protocol AnyCellViewModel {
    static var cellType: ReusableView.Type { get }
    func setup(cell: ReusableView)
}

public protocol CellViewModel: AnyCellViewModel {
    associatedtype CellType: ReusableView
    func setup(cell: CellType)
}

public extension CellViewModel {
    static var cellType: ReusableView.Type {
        return CellType.self
    }
    func setup(cell: ReusableView) {
        self.setup(cell: cell as! CellType)
    }
}

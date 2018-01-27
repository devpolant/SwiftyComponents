//
//  Cell+ViewModel.swift
//  Components
//
//  Created by Anton Poltoratskyi on 27.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation
import UIKit

public protocol AnyCellViewModel {
    static var cellType: UIView.Type { get }
    func setup(cell: UIView)
}

public protocol CellViewModel: AnyCellViewModel {
    associatedtype CellType: UIView
    func setup(cell: CellType)
}

extension CellViewModel {
    static var cellType: UIView.Type {
        return CellType.self
    }
    func setup(cell: UIView) {
        self.setup(cell: cell as! CellType)
    }
}

//
//  Cell+ViewModel.swift
//  Components
//
//  Created by Anton Poltoratskyi on 27.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit

public typealias AnyViewCell = UIView

public protocol AnyCellViewModel: Reusable {
    static var cellType: AnyViewCell.Type { get }
    func setup(cell: AnyViewCell)
}
extension AnyCellViewModel {
    public static var reuseIdentifier: String {
        return String(describing: cellType)
    }
}

public protocol CellViewModel: AnyCellViewModel {
    associatedtype Cell: AnyViewCell
    func setup(cell: Cell)
}

public extension CellViewModel {
    static var cellType: AnyViewCell.Type {
        return Cell.self
    }
    func setup(cell: AnyViewCell) {
        self.setup(cell: cell as! Cell)
    }
}

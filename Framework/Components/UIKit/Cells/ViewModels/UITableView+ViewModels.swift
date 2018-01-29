//
//  UITableView+ViewModels.swift
//  Components
//
//  Created by Anton Poltoratskyi on 27.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit

extension UITableView {
    
    open func dequeueReusableCell(withModel viewModel: AnyCellViewModel, for indexPath: IndexPath) -> UITableViewCell {
        let identifier = type(of: viewModel).reuseIdentifier
        let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        viewModel.setup(cell: cell)
        return cell
    }
    
    open func register(viewModels: AnyCellViewModel.Type...) {
        for modelType in viewModels {
            let identifier = modelType.reuseIdentifier
            register(modelType.cellType, forCellReuseIdentifier: identifier)
        }
    }
    
    open func register<T: CellViewModel>(nibModel: T.Type) where T.Cell: XibInitializable {
        let identifier = T.reuseIdentifier
        let nibName = T.Cell.xibFileName
        let nib = UINib(nibName: nibName, bundle: Bundle(for: T.Cell.self))
        register(nib, forCellReuseIdentifier: identifier)
    }
}

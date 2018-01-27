//
//  UITableView+ViewModels.swift
//  Components
//
//  Created by Anton Poltoratskyi on 27.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    open func dequeueReusableCell(withModel viewModel: AnyCellViewModel, for indexPath: IndexPath) -> UITableViewCell {
        let identifier = type(of: viewModel).cellType.reuseIdentifier
        let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        viewModel.setup(cell: cell)
        return cell
    }
    
    func register(viewModels: AnyCellViewModel.Type...) {
        for modelType in viewModels {
            let identifier = modelType.cellType.reuseIdentifier
            register(modelType.cellType, forCellReuseIdentifier: identifier)
        }
    }
    
    func register(nibModels: AnyCellViewModel.Type...) {
        for modelType in nibModels {
            let identifier = modelType.cellType.reuseIdentifier
            let nib = UINib(nibName: identifier, bundle: nil)
            register(nib, forCellReuseIdentifier: identifier)
        }
    }
}

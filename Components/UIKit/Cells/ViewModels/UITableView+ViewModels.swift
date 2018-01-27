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
        let identifier = String(describing: type(of: viewModel).cellType)
        let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        viewModel.setup(cell: cell)
        return cell
    }
    
    func register(viewModels: AnyCellViewModel.Type...) {
        for modelType in viewModels {
            let identifier = String(describing: modelType.cellType)
            register(modelType.cellType, forCellReuseIdentifier: identifier)
        }
    }
    
    func register(nibModels: AnyCellViewModel.Type...) {
        for modelType in nibModels {
            let identifier = String(describing: modelType.cellType)
            let nib = UINib(nibName: identifier, bundle: nil)
            register(nib, forCellReuseIdentifier: identifier)
        }
    }
}

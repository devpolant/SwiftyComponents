//
//  UICollectionView+ViewModel.swift
//  Components
//
//  Created by Anton Poltoratskyi on 27.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    open func dequeueReusableCell(withModel viewModel: AnyCellViewModel, for indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = type(of: viewModel).cellType.reuseIdentifier
        let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        viewModel.setup(cell: cell)
        return cell
    }
    
    open func register(viewModels: AnyCellViewModel.Type...) {
        for modelType in viewModels {
            let identifier = modelType.cellType.reuseIdentifier
            register(modelType.cellType, forCellWithReuseIdentifier: identifier)
        }
    }
    
    open func register<T: CellViewModel>(nibModel: T.Type) where T.CellType: XibInitializable {
        let identifier = nibModel.cellType.reuseIdentifier
        let nibName = T.CellType.xibFileName
        let nib = UINib(nibName: nibName, bundle: Bundle(for: T.CellType.self))
        register(nib, forCellWithReuseIdentifier: identifier)
    }
}

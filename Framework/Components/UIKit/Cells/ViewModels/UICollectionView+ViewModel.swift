//
//  UICollectionView+ViewModel.swift
//  Components
//
//  Created by Anton Poltoratskyi on 27.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    open func dequeueReusableCell(withModel viewModel: AnyCellViewModel, for indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = type(of: viewModel).reuseIdentifier
        let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        viewModel.setup(cell: cell)
        return cell
    }
    
    open func register<T: CellViewModel>(viewModel: T.Type) {
        register(T.Cell.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    open func register<T: CellViewModel>(nibModel: T.Type) where T.Cell: XibInitializable {
        let identifier = T.reuseIdentifier
        let nibName = T.Cell.xibFileName
        let nib = UINib(nibName: nibName, bundle: Bundle(for: T.Cell.self))
        register(nib, forCellWithReuseIdentifier: identifier)
    }
}

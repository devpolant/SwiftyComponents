//
//  UICollectionView+ReusableCell.swift
//  Components
//
//  Created by Anton Poltoratskyi on 30.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit

extension UICollectionView {
    public typealias ReusableCell = UICollectionViewCell & Reusable
    
    open func dequeueReusableCell<T: ReusableCell>(ofType cellType: T.Type, for indexPath: IndexPath) -> UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: T.uniqueIdentifier, for: indexPath) as! T
    }
    
    open func register<T: ReusableCell>(cell: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.uniqueIdentifier)
    }
    
    open func register<T: ReusableCell>(nib: T.Type) where T: XibInitializable {
        let nib = UINib(nibName: T.xibFileName, bundle: Bundle(for: T.self))
        register(nib, forCellWithReuseIdentifier: T.uniqueIdentifier)
    }
}

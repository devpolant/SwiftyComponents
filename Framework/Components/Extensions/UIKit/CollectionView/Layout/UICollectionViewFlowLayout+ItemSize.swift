//
//  UICollectionViewFlowLayout+ItemSize.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit

extension UICollectionViewFlowLayout {
    
    struct ItemLayout {
        var bounds: CGRect
        var horizontalVisibleCount: Int
        var verticalVisibleCount: Int
        var horizontalSpacing: CGFloat = 0
        var verticalSpacing: CGFloat = 0
    }
    
    func setupItemSize(for layout: ItemLayout) {
        let horizontalVisibleCount = CGFloat(layout.horizontalVisibleCount)
        let verticalVisibleCount = CGFloat(layout.verticalVisibleCount)
        
        let width = (layout.bounds.width - (horizontalVisibleCount + 1) * layout.horizontalSpacing) / horizontalVisibleCount
        
        let height = (layout.bounds.height - (verticalVisibleCount + 1) * layout.verticalSpacing) / verticalVisibleCount
        
        minimumInteritemSpacing = layout.horizontalSpacing
        minimumLineSpacing = layout.verticalSpacing
        
        sectionInset.left = layout.horizontalSpacing
        sectionInset.right = layout.horizontalSpacing
        
        itemSize = CGSize(width: width, height: height)
    }
}

//
//  RoundView.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2019 Anton Poltoratskyi. All rights reserved.
//

import UIKit

public class RoundView: BaseView {
    
    public override func baseSetup() {
        super.baseSetup()
        layer.masksToBounds = true
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
}

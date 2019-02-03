//
//  TypingBoldIndicatorView.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

public final class TypingBoldIndicatorView: BaseView {
    
    public var horizontalInset: CGFloat = 4 {
        didSet {
            indicatorView.snp.updateConstraints { maker in
                maker.left.equalToSuperview().offset(horizontalInset)
                maker.right.equalToSuperview().inset(horizontalInset)
            }
        }
    }
    
    public var circleSize: CGFloat = 8 {
        didSet {
            indicatorView.snp.updateConstraints { maker in
                maker.width.height.equalTo(circleSize)
            }
        }
    }
    
    public var circleColor: UIColor = .lightGray {
        didSet {
            indicatorView.backgroundColor = circleColor
        }
    }
    
    
    // MARK: - Views
    
    private let indicatorView = RoundView()
    
    
    // MARK: - Setup
    
    public override func baseSetup() {
        super.baseSetup()
        
        backgroundColor = .clear
        indicatorView.backgroundColor = backgroundColor
        
        addSubview(indicatorView)
        indicatorView.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.left.equalToSuperview().offset(horizontalInset)
            maker.right.equalToSuperview().inset(horizontalInset)
            maker.width.height.equalTo(circleSize)
        }
    }
}

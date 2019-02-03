//
//  TypingView.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit
import SnapKit

public final class TypingView: BaseView {
    
    // MARK: - Appearance
    
    public struct Appearance {
        public enum Indicator {
            case dots(UIColor)
            case circle(UIColor)
        }
        public let indicator: Indicator
        public let textColor: UIColor
        public let textFont: UIFont
        public let senderInfo: String?
        public let typingInfo: String
        
        public init(indicator: Indicator,
                    textColor: UIColor,
                    textFont: UIFont,
                    senderInfo: String?,
                    typingInfo: String) {
            self.indicator = indicator
            self.textColor = textColor
            self.textFont = textFont
            self.senderInfo = senderInfo
            self.typingInfo = typingInfo
        }
    }
    
    
    // MARK: - Views
    
    private lazy var indicatorContainer: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.required, for: .horizontal)
        addSubview(view)
        return view
    }()
    
    private lazy var senderInfoLabel: UILabel = {
        let label = UILabel()
        addSubview(label)
        return label
    }()
    
    
    // MARK: - Setup
    
    public override func baseSetup() {
        super.baseSetup()
        
        indicatorContainer.snp.makeConstraints { maker in
            maker.top.bottom.left.equalToSuperview()
        }
        
        senderInfoLabel.snp.makeConstraints { maker in
            maker.top.bottom.right.equalToSuperview()
            maker.left.equalTo(indicatorContainer.snp.right).offset(Constraints.senderInfo.leftOffset.adjustedByWidth)
        }
    }
    
    
    // MARK: - Layout
    
    public func update(_ appearance: Appearance) {
        switch appearance.indicator {
        case let .dots(color):
            setupDotsIndicator(color: color)
        case let .circle(color):
            setupCircleIndicator(color: color)
        }
        
        senderInfoLabel.font = appearance.textFont
        senderInfoLabel.textColor = appearance.textColor
        senderInfoLabel.text = appearance.senderInfo
            .flatMap { "\($0) \(appearance.typingInfo)" } ?? appearance.typingInfo
    }
    
    private func setupDotsIndicator(color: UIColor) {
        guard !indicatorContainer.subviews.contains(where: { $0 is TypingIndicatorView }) else { return }
        
        indicatorContainer.subviews.forEach { $0.removeFromSuperview() }
        
        let indicatorView = TypingIndicatorView()
        indicatorView.itemColor = color
        indicatorView.itemSize = Constraints.indicator.dotsSize.adjustedByWidth
        indicatorView.itemPadding = Constraints.indicator.dotsPadding.adjustedByWidth
        
        indicatorView.setContentCompressionResistancePriority(.required, for: .horizontal)
        indicatorView.setContentHuggingPriority(.required, for: .horizontal)
        
        indicatorContainer.addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints(makeIndicatorViewConstraints())
    }
    
    private func setupCircleIndicator(color: UIColor) {
        guard !indicatorContainer.subviews.contains(where: { $0 is RecordingIndicatorView }) else { return }
        
        indicatorContainer.subviews.forEach { $0.removeFromSuperview() }
        
        let indicatorView = RecordingIndicatorView()
        indicatorContainer.addSubview(indicatorView)
        
        indicatorView.circleColor = color
        indicatorView.circleSize = Constraints.indicator.circleSize.adjustedByWidth
        indicatorView.horizontalInset = Constraints.indicator.horizontalInset.adjustedByWidth
        
        indicatorView.snp.makeConstraints(makeIndicatorViewConstraints())
    }
    
    private func makeIndicatorViewConstraints() -> (ConstraintMaker) -> Void {
        return { maker in
            maker.centerY.equalToSuperview().offset(Constraints.indicator.centerVerticalOffset.adjustedByWidth)
            maker.left.right.equalToSuperview()
        }
    }
    
    
    // MARK: - Constraints
    
    private enum Constraints {
        
        enum indicator {
            static let circleSize: CGFloat = 8
            static let dotsSize: CGFloat = 3
            static let dotsPadding: CGFloat = 4
            
            static let horizontalInset: CGFloat = 4
            static let centerVerticalOffset: CGFloat = 1
        }
        
        enum senderInfo {
            static let leftOffset: CGFloat = 4
        }
    }
}

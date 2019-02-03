//
//  TypingIndicatorView.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit

public final class TypingIndicatorView: BaseView {
    
    public var itemsCount: Int = 3 {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    public var itemPadding: CGFloat = 4 {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    public var itemSize: CGFloat = 4 {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    public var itemColor: UIColor = .lightGray {
        didSet {
            setupColor()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        let width = itemSize * CGFloat(itemsCount) + itemPadding * CGFloat(itemsCount - 1)
        return CGSize(width: width, height: itemSize)
    }
    
    
    // MARK: - Layers
    
    public override class var layerClass: AnyClass {
        return CAReplicatorLayer.self
    }
    
    private var animationLayer: CAReplicatorLayer {
        return layer as! CAReplicatorLayer
    }
    
    private let itemLayer = CAShapeLayer()
    
    
    // MARK: - Setup
    
    public override func baseSetup() {
        super.baseSetup()
        animationLayer.addSublayer(itemLayer)
        animationLayer.masksToBounds = true
        setupColor()
    }
    
    private func setupColor() {
        itemLayer.backgroundColor = itemColor.cgColor
    }
    
    
    // MARK: - Layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        itemLayer.frame.size = CGSize(width: itemSize, height: itemSize)
        itemLayer.cornerRadius = itemSize / 2
        
        animationLayer.instanceCount = itemsCount
        animationLayer.instanceTransform = CATransform3DMakeTranslation(itemSize + itemPadding, 0, 0)
        animationLayer.instanceAlphaOffset = Float(Animation.toValue - Animation.fromValue) / Float(itemsCount - 1)
        animationLayer.instanceDelay = Animation.duration / Double(itemsCount)
        
        addAnimation()
    }
    
    
    // MARK: - Animation
    
    private func addAnimation() {
        guard !itemLayer.hasAnimation(forKey: Animation.key) else {
            return
        }
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = Animation.fromValue
        animation.toValue = Animation.toValue
        animation.duration = Animation.duration
        animation.autoreverses = true
        animation.repeatCount = .infinity
        
        itemLayer.add(animation, forKey: Animation.key)
    }
    
    private enum Animation {
        static let key = "typing"
        static let duration = 0.5
        static let fromValue = 0.5
        static let toValue = 1.0
    }
}

//
//  SecureCodeContainerView.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit
import SnapKit

public final class SecureCodeContainerView: BaseView {
    
    public var appearance: Appearance = .default {
        didSet {
            setupAppearance()
        }
    }
    
    public var fullFillHandler: ((String, Bool) -> Void)? {
        didSet {
            codeInputView.fullFillHandler = fullFillHandler
        }
    }
    
    public var currentInputText: String {
        return codeInputView.inputText
    }
    
    
    // MARK: - Views
    
    public private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        addSubview(label)
        return label
    }()
    
    private lazy var codeInputView: SecureCodeInputView = {
        let inputView = SecureCodeInputView()
        addSubview(inputView)
        return inputView
    }()
    
    public private(set) lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        addSubview(label)
        return label
    }()
    
    
    // MARK: - Setup
    
    public override func baseSetup() {
        super.baseSetup()
        setupAppearance()
        setupLayout()
    }
    
    private func setupLayout() {
        titleLabel.textAlignment = .center
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.left.right.equalToSuperview()
        }
        
        codeInputView.snp.makeConstraints { maker in
            let top = Constraints.codeInputView.top.adjustedByWidth
            let height = Constraints.codeInputView.height.adjustedByWidth
            
            maker.top.equalTo(titleLabel.snp.bottom).offset(top)
            maker.left.greaterThanOrEqualToSuperview()
            maker.right.lessThanOrEqualToSuperview()
            maker.centerX.equalToSuperview()
            maker.height.equalTo(height)
        }
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.setContentHuggingPriority(.required, for: .vertical)
        descriptionLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        descriptionLabel.snp.makeConstraints { maker in
            let top = Constraints.codeInputView.bottom.adjustedByWidth
            
            maker.top.equalTo(codeInputView.snp.bottom).offset(top)
            maker.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupAppearance() {
        titleLabel.font = appearance.titleFont
        titleLabel.textColor = appearance.titleColor
        codeInputView.tintColor = appearance.tintColor
        codeInputView.textColor = appearance.textColor
        codeInputView.font = appearance.textFont
        descriptionLabel.font = appearance.descriptionFont
        descriptionLabel.textColor = appearance.descriptionColor
    }
    
    
    // MARK: - Actions
    
    public func beginEditing() {
        codeInputView.beginEditing()
    }
    
    
    // MARK: - Layout
    
    private enum Constraints {
        
        enum codeInputView {
            static let top = 16.0
            static let height = 64.0
            static let bottom = 8.0
        }
    }
}

// TODO: move Testable protocol to NynjaUIKit
extension SecureCodeContainerView {
    
    func setupTestingKeys() {
        titleLabel.accessibilityIdentifier = "code_input_title_label"
        codeInputView.accessibilityIdentifier = "code_input_container"
        descriptionLabel.accessibilityIdentifier = "code_input_description_label"
    }
}

extension SecureCodeContainerView {
    
    public struct Appearance {
        public let tintColor: UIColor
        public let titleFont: UIFont
        public let titleColor: UIColor
        public let textFont: UIFont
        public let textColor: UIColor
        public let descriptionFont: UIFont
        public let descriptionColor: UIColor
        
        public init(tintColor: UIColor,
                    titleFont: UIFont,
                    titleColor: UIColor,
                    textFont: UIFont,
                    textColor: UIColor,
                    descriptionFont: UIFont,
                    descriptionColor: UIColor) {
            self.tintColor = tintColor
            self.titleFont = titleFont
            self.titleColor = titleColor
            self.textFont = textFont
            self.textColor = textColor
            self.descriptionFont = descriptionFont
            self.descriptionColor = descriptionColor
        }
        
        static var `default`: Appearance {
            return Appearance(tintColor: .red,
                              titleFont: .systemFont(ofSize: 16, weight: .medium),
                              titleColor: .white,
                              textFont: .systemFont(ofSize: 16),
                              textColor: .white,
                              descriptionFont: .systemFont(ofSize: 16, weight: .medium),
                              descriptionColor: .lightGray)
        }
    }
}

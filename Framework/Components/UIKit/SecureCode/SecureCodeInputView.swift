//
//  SecureCodeInputView.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit
import SnapKit

final class SecureCodeInputView: BaseView {
    
    var font: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet {
            setupFont()
        }
    }
    
    var textColor: UIColor = UIColor.white {
        didSet {
            setupTextColor()
        }
    }
    
    var spacing: CGFloat = CGFloat(8.0).adjustedByWidth {
        didSet {
            stackContainer.spacing = spacing
        }
    }
    
    var itemsCount: Int = 6 {
        didSet {
            stackContainer.removeArrangedSubviews()
            setupItems()
        }
    }
    
    var fullFillHandler: ((String, Bool) -> Void)? {
        didSet {
            textController.allFieldsFilledAction = fullFillHandler
        }
    }
    
    var inputText: String {
        return textController.fullText
    }
    
    override var tintColor: UIColor! {
        didSet {
            setupTintColor()
        }
    }
    
    // MARK: - Views
    
    private lazy var stackContainer: UIStackView = {
        let stackContainer = UIStackView()
        stackContainer.axis = .horizontal
        stackContainer.distribution = .fillEqually
        stackContainer.spacing = spacing
        
        addSubview(stackContainer)
        stackContainer.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.top.greaterThanOrEqualToSuperview()
            maker.bottom.lessThanOrEqualToSuperview()
            maker.centerY.equalToSuperview()
        }
        
        return stackContainer
    }()
    
    private var inputFields: [UnderlinedTextField<TextField>] = []
    
    private let textController = TextFieldsController()
    
    
    // MARK: - Setup
    
    override func baseSetup() {
        super.baseSetup()
        setupItems()
        setupTintColor()
        setupFont()
        setupTextColor()
    }
    
    private func setupItems() {
        for index in 0..<itemsCount {
            let fieldContainer = makeInputField()
            
            fieldContainer.snp.makeConstraints { maker in
                maker.width.equalTo(Constraints.itemWidth.adjustedByWidth)
            }
            fieldContainer.textField.accessibilityIdentifier = "code_field_\(index)"
            
            inputFields.append(fieldContainer)
            
            stackContainer.addArrangedSubview(fieldContainer)
        }
        textController.add(fields: inputFields.map { $0.textField })
    }
    
    private func setupTintColor() {
        inputFields.forEach {
            $0.tintColor = tintColor
            $0.underlineColor = tintColor
            $0.highlighedUnderlineColor = tintColor
        }
    }
    
    private func setupFont() {
        inputFields.forEach { $0.font = font }
    }
    
    private func setupTextColor() {
        inputFields.forEach { $0.textColor = textColor }
    }
    
    private func makeInputField() -> UnderlinedTextField<TextField> {
        let field = UnderlinedTextField<TextField>()
        
        field.delegate = textController
        
        // Security rules
        field.shouldResetAfterBackground = true
        field.shouldCacheInputs = false
        
        // Appearance
        field.lineWidth = Constraints.lineWidth
        field.lineOffset = Constraints.lineOffset
        field.underlineColor = tintColor
        field.highlighedUnderlineColor = tintColor
        field.keyboardType = .numberPad
        field.textAlignment = .center
        
        return field
    }
    
    
    // MARK: - Actions
    
    func beginEditing() {
        _ = inputFields.first?.textField.becomeFirstResponder()
    }
    
    
    // MARK: - Layout
    
    private enum Constraints {
        static let itemWidth: CGFloat = 44.0
        static let lineWidth: CGFloat = 2.0
        static let lineOffset: CGFloat = 1.0
    }
}

// MARK: - UITextFieldDelegate

extension SecureCodeInputView {
    
    final class TextFieldsController: NSObject, UITextFieldDelegate {
        
        private var fields: [UITextField] = []
        
        var allFieldsFilledAction: ((_ code: String, _ fullfilled: Bool) -> Void)?
        
        var fullText: String {
            return fields.compactMap { $0.text }.joined()
        }
        
        func add(fields: [UITextField]) {
            self.fields.forEach { $0.delegate = nil }
            self.fields = fields
            self.fields.forEach { $0.delegate = self }
        }
        
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            return true
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            textField.moveCursorToEnd()
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            defer { notify() }
            
            // 'string' can be empty only on deleting.
            if string.isEmpty {
                handleDelete(on: textField, string: string)
                return false
            }
            
            // check paste or autofill
            if string.count > 1 {
                handlePasted(text: string, on: textField)
                return false
            }
            
            let currentText = textField.text ?? ""
            let result = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            if result.isEmpty {
                handleDelete(on: textField, string: string)
                
            } else if result.count == 1 {
                handleReplace(on: textField, string: string)
                
            } else {
                // 'textField' is filled, so need to move to the next field.
                handleNextInput(on: textField, string: string)
            }
            
            return false
        }
        
        private func handlePasted(text: String, on currentField: UITextField) {
            let skipCount = max(fields.count - text.count, 0)
            
            for (textField, character) in zip(fields.dropFirst(skipCount), text) {
                textField.text = String(character)
            }
        }
        
        private func handleDelete(on textField: UITextField, string: String) {
            textField.text = string
            fields.previous(before: textField)?.becomeFirstResponder()
        }
        
        private func handleReplace(on textField: UITextField, string: String) {
            textField.text = string
        }
        
        private func handleNextInput(on textField: UITextField, string: String) {
            guard let nextField = fields.next(after: textField) else {
                return
            }
            nextField.text = string
            nextField.becomeFirstResponder()
        }
        
        private func notify() {
            let isAllFieldsFilled = !fields.contains { $0.text == nil || $0.text!.isEmpty }
            allFieldsFilledAction?(fullText, isAllFieldsFilled)
        }
    }
}

// TODO: move to Core
fileprivate extension Array where Element: Equatable {
    
    func next(after element: Element) -> Element? {
        guard let indexOfCurrent = index(of: element) else {
            return nil
        }
        
        let indexForNewElement = index(after: indexOfCurrent)
        
        if indexForNewElement <= count - 1 {
            return self[indexForNewElement]
        } else {
            return nil
        }
    }
    
    func previous(before element: Element) -> Element? {
        guard let indexOfCurrent = index(of: element) else {
            return nil
        }
        
        let indexForNewElement = index(before: indexOfCurrent)
        
        if indexForNewElement >= 0 {
            return self[indexForNewElement]
        } else {
            return nil
        }
    }
}

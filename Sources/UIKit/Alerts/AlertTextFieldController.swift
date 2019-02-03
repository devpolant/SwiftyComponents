//
//  AlertTextFieldController.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit

public final class AlertTextFieldController: NSObject, UITextFieldDelegate {
    
    public internal(set) weak var textField: UITextField? {
        didSet {
            textField?.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
            textField?.delegate = self
        }
    }
    
    public var text: String? {
        return textField?.text
    }
    
    
    /// Don't assign textField's delegate inside this handler.
    public var configurationHandler: ((UITextField) -> Void)?
    
    public var textChangeHandler: ((UITextField) -> Void)?
    
    public var shouldChangeTextHandler: ((UITextField) -> Bool)?
    
    @objc private func textDidChange(sender: UITextField) {
        textChangeHandler?(sender)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return shouldChangeTextHandler?(textField) ?? true
    }
}

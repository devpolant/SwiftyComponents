//
//  Alert.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit

public final class Alert {
    public let title: String?
    public let message: String?
    public let style: Style
    public let actions: [Action]
    
    private var textFieldControllers: [AlertTextFieldController] = []
    
    public init(title: String? = nil, message: String? = nil, style: Style = .alert, actions: [Action]) {
        self.title = title
        self.message = message
        self.style = style
        self.actions = actions
    }
    
    public func addTextField(with controller: AlertTextFieldController) {
        textFieldControllers.append(controller)
    }
    
    public func makeAlertController() -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style.nativeStyle)
        actions.forEach {
            let action = $0.makeNativeAction()
            $0.alertAction = action
            alert.addAction(action)
        }
        
        textFieldControllers.forEach { controller in
            alert.addTextField { textField in
                controller.configurationHandler?(textField)
                controller.textField = textField
            }
        }
        
        return alert
    }
    
    public enum Style {
        case alert
        case actionSheet
        
        public var nativeStyle: UIAlertController.Style {
            switch self {
            case .alert:
                return .alert
            case .actionSheet:
                return .actionSheet
            }
        }
    }
    
    public final class Action {
        public enum Style {
            case `default`
            case cancel
            case destructive
            
            var nativeStyle: UIAlertAction.Style {
                switch self {
                case .default:
                    return .default
                case .cancel:
                    return .cancel
                case .destructive:
                    return .destructive
                }
            }
        }
        
        public let title: String?
        public let style: Style
        public let handler: ((Action) -> Void)?
        public var isEnabled: Bool {
            didSet {
                alertAction?.isEnabled = isEnabled
            }
        }
        
        weak var alertAction: UIAlertAction?
        
        public init(title: String?, style: Style, isEnabled: Bool = true, handler: ((Action) -> Void)? = nil) {
            self.title = title
            self.style = style
            self.isEnabled = isEnabled
            self.handler = handler
        }
        
        public func makeNativeAction() -> UIAlertAction {
            let action = UIAlertAction(title: title, style: style.nativeStyle) { _ in
                self.handler?(self)
            }
            action.isEnabled = isEnabled
            
            return action
        }
    }
}

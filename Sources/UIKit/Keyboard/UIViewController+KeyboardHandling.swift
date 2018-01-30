//
//  UIViewController+KeyboardHandling.swift
//  Components
//
//  Created by Anton Poltoratskyi on 30.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit

extension UIViewController {
    public func registerForKeyboardNotifications() {
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardDidShow(notification:)),
                           name: .UIKeyboardDidShow,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(keyboardWillHide(notification:)),
                           name: .UIKeyboardWillHide,
                           object: nil)
    }
    
    public func unregisterForKeyboardNotifications() {
        let center = NotificationCenter.default
        center.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
        center.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        (self as? KeyboardInteracting)?.handleKeyboardShow(userInfo: userInfo)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        (self as? KeyboardInteracting)?.handleKeyboardHide()
    }
}

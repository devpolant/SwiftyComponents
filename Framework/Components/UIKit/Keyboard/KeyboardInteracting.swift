//
//  KeyboardInteraction.swift
//  Components
//
//  Created by Anton Poltoratskyi on 30.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit

public typealias KeyboardInputView = UIView & UITextInput // or [UITextField]

public protocol KeyboardInteracting: class {
    var scrollView: UIScrollView! { get }
    var keyboardInputViews: [KeyboardInputView] { get }
    
    func handleKeyboardShow(userInfo: [AnyHashable: Any])
    func handleKeyboardHide()
}

extension KeyboardInteracting where Self: UIViewController {
    private var activeView: UIView? {
        return keyboardInputViews.first { $0.isFirstResponder }
    }
    
    // MARK: Events
    
    public func handleKeyboardShow(userInfo: [AnyHashable: Any]) {
        guard
            let activeInputView = self.activeView,
            let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        else {
            return
        }
        addTapGesture()

        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        setScrollInsets(contentInsets)

        // If active text field is hidden by keyboard, scroll it so it's visible.
        let activeViewFrame = activeInputView.frame
        guard let activeRect = activeInputView.superview?.convert(activeViewFrame, to: scrollView) else {
            return
        }
        var rootFrame = self.view.frame
        rootFrame.size.height -= keyboardSize.height

        if !(rootFrame.contains(activeRect)) {
            scrollView?.scrollRectToVisible(activeRect, animated: true)
        }
    }

    public func handleKeyboardHide() {
        setScrollInsets(.zero)
        removeTapGesture()
    }
    
    private func setScrollInsets(_ insets: UIEdgeInsets) {
        scrollView?.contentInset = insets
        scrollView?.scrollIndicatorInsets = insets
    }
    
    // MARK: Tap Gesture
    
    private var tapIdentifier: String {
        return "tap-on-whitespace"
    }
    
    private func addTapGesture() {
        /// Workaround to use gesture recognizer in protocol extension.
        /// Swift 4 requires that methods called with selectors must be marked as @objc which is not allowed in protocol extentions
        let tap = ClosureTapRecognizer(identifier: tapIdentifier) { [weak self] recognizer in
            self?.tapOnWhiteSpace(recognizer: recognizer)
        }
        self.view.addGestureRecognizer(tap)
    }
    
    private func removeTapGesture() {
        let identifier = tapIdentifier
        self.view.gestureRecognizers?
            .first { ($0 as? ClosureTapRecognizer)?.identifier == identifier }
            .map { self.view.removeGestureRecognizer($0) }
    }
    
    private func tapOnWhiteSpace(recognizer: UITapGestureRecognizer) {
        activeView?.resignFirstResponder()
        removeTapGesture()
    }
}

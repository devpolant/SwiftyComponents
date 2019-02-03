//
//  InputTextStorageDelegate.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2019 Anton Poltoratskyi. All rights reserved.
//

import UIKit

public protocol InputTextStorageDelegate: class {
    func inputTextStorage(_ textStorage: InputTextStorage,
                          modifiedAttributesFor proposedAttributes: TextAttributes?,
                          range: NSRange) -> TextAttributes?
}

extension InputTextStorageDelegate {
    public func inputTextStorage(_ textStorage: InputTextStorage,
                                 modifiedAttributesFor proposedAttributes: TextAttributes?,
                                 range: NSRange) -> TextAttributes? {
        return proposedAttributes
    }
}

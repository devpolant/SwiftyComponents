//
//  InputTextStorage.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2019 Anton Poltoratskyi. All rights reserved.
//

import UIKit

/* Note for subclassing NSTextStorage: NSTextStorage is a semi-abstract subclass of NSMutableAttributedString. It implements change management (beginEditing/endEditing), verification of attributes, delegate handling, and layout management notification. The one aspect it does not implement is the actual attributed string storage --- this is left up to the subclassers, which need to override the two NSMutableAttributedString primitives in addition to two NSAttributedString primitives:
 
 - (NSString *)string;
 - (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range;
 
 - (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str;
 - (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range;
 
 These primitives should perform the change then call edited:range:changeInLength: to get everything else to happen.
 */
public final class InputTextStorage: NSTextStorage {
    
    private let backingStore = NSMutableAttributedString()
    
    public weak var inputDelegate: InputTextStorageDelegate?
    
    public override var string: String {
        return backingStore.string
    }
    
    public override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        return backingStore.attributes(at: location, effectiveRange: range)
    }
    
    public override func replaceCharacters(in range: NSRange, with str: String) {
        performEdit {
            backingStore.replaceCharacters(in: range, with: str)
            let diff = str.utf16.count - range.length
            edited(.editedCharacters, range: range, changeInLength: diff)
        }
    }
    
    public override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        performEdit {
            let attributes = inputDelegate?.inputTextStorage(self, modifiedAttributesFor: attrs, range: range) ?? attrs
            backingStore.setAttributes(attributes, range: range)
            edited(.editedAttributes, range: range, changeInLength: 0)
        }
    }
    
    private func performEdit(block: () -> Void) {
        beginEditing()
        block()
        endEditing()
    }
}

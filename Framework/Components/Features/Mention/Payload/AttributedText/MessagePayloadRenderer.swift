//
//  MessagePayloadRenderer.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

final class MessagePayloadRenderer: MessagePayloadRendererInput {
    static let defaultTextColor = UIColor.darkText
    static let defaultMentionColor = UIColor.blue
    
    let textFont: UIFont
    let textColor: UIColor
    let mentionColor: UIColor
    
    private init(textFont: UIFont, textColor: UIColor, mentionColor: UIColor) {
        self.textFont = textFont
        self.textColor = textColor
        self.mentionColor = mentionColor
    }
    
    func processPayload(with mentions: [MentionInfo]?,
                        in attributedText: NSMutableAttributedString,
                        mentionAttributes: [NSAttributedString.Key: Any]) -> PayloadProcessingResult {
        
        guard let mentions = mentions, !mentions.isEmpty else {
            return (attributedText, nil)
        }
        
        var shiftedMentions: [Mention] = []
        
        var offset = 0
        for mention in mentions {
            let alias = "@\(mention.alias)"
            
            var mentionAttributes = mentionAttributes
            mentionAttributes[.mention] = mention
            
            let tagRange = mention.range.utf16Encoded.shifted(by: offset).nsRange
            attributedText.replaceCharacters(in: tagRange, with: alias)
            
            let attrRange = tagRange.location..<tagRange.location + alias.utf16.count
            let attributesRange = attrRange.nsRange
            attributedText.setAttributes(mentionAttributes, range: attributesRange)
            
            let shifted = Mention(indices: attrRange,
                                  memberId: mention.memberId,
                                  accountId: mention.accountId,
                                  alias: mention.alias)
            shiftedMentions.append(shifted)
            
            offset -= (tagRange.length - alias.utf16.count)
        }
        
        return (attributedText, shiftedMentions)
    }
}

// MARK: - Links

extension MessagePayloadRenderer {
    
    static func linkRenderer(font: UIFont, textColor: UIColor = defaultTextColor) -> MessagePayloadRendererInput {
        return MessagePayloadRenderer(textFont: font, textColor: textColor, mentionColor: defaultMentionColor)
    }
}

// MARK: - Plain Text

extension MessagePayloadRenderer {
    
    static func processPlainTextPayload(with mentions: [MentionInfo]?,
                                        in text: String) -> PlainPayloadProcessingResult {
        
        guard let mentions = mentions, !mentions.isEmpty else {
            return (text, nil)
        }

        var text = text
        
        var shiftedMentions: [Mention] = []
        
        var offset = 0
        for mention in mentions {
            let alias = "@\(mention.alias)"
            
            let utf16EncodedRange = mention.range.utf16Encoded.shifted(by: offset)
            let tagRange = utf16EncodedRange.stringIndices
            text.removeSubrange(tagRange)
            text.insert(contentsOf: alias, at: tagRange.lowerBound)
            
            let attrRange = utf16EncodedRange.lowerBound..<utf16EncodedRange.lowerBound + alias.utf16.count
            
            let shifted = Mention(indices: attrRange,
                                  memberId: mention.memberId,
                                  accountId: mention.accountId,
                                  alias: mention.alias)
            shiftedMentions.append(shifted)
            
            offset -= (utf16EncodedRange.count - alias.utf16.count)
        }
        
        return (text, shiftedMentions)
    }
    
    static func processPlainTextPayload<Result, Element>(into: inout Result,
                                                         with mentions: [MentionInfo]?,
                                                         in text: String,
                                                         replacement: (MentionInfo) -> String,
                                                         transform: (_ indices: Range<Int>, _ mantionInfo: MentionInfo) -> Element,
                                                         updateResult: (inout Result, Element) throws -> () ) -> (text: String, mentions: Result?) {
        
        guard let mentions = mentions, !mentions.isEmpty else {
            return (text, nil)
        }
        
        var text = text
        
        var offset = 0
        for mention in mentions {
            let alias = replacement(mention)
            
            let utf16EncodedRange = mention.range.utf16Encoded.shifted(by: offset)
            let tagRange = utf16EncodedRange.stringIndices
            text.removeSubrange(tagRange)
            text.insert(contentsOf: alias, at: tagRange.lowerBound)
            
            let attrRange = utf16EncodedRange.lowerBound..<utf16EncodedRange.lowerBound + alias.utf16.count

            let element = transform(attrRange, mention)
            try? updateResult(&into, element)
            
            offset -= (utf16EncodedRange.count - alias.utf16.count)
        }
        
        return (text, into)
    }
}

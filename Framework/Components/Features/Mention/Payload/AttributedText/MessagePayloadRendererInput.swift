//
//  MessagePayloadRendererInput.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

typealias PayloadProcessingResult = (text: NSAttributedString, mentions: [Mention]?)
typealias PlainPayloadProcessingResult = (text: String, mentions: [Mention]?)

protocol MessagePayloadRendererInput: class {
    var textFont: UIFont { get }
    var textColor: UIColor { get }
    var mentionColor: UIColor { get }
    
    func processPayload(with mentions: [MentionInfo]?,
                        in text: String?) -> PayloadProcessingResult
    
    func processPayload(with mentions: [MentionInfo]?,
                        in attributedText: NSMutableAttributedString) ->  PayloadProcessingResult
    
    func processPayload(with mentions: [MentionInfo]?,
                        in attributedText: NSMutableAttributedString,
                        mentionAttributes: [NSAttributedString.Key: Any]) -> PayloadProcessingResult
    
    static func processPlainTextPayload(with mentions: [MentionInfo]?,
                                        in text: String) -> PlainPayloadProcessingResult
}

extension MessagePayloadRendererInput {
    
    private var textAttributes: [NSAttributedString.Key: Any] {
        return [
            .foregroundColor: textColor,
            .font: textFont
        ]
    }
    
    private var mentionAttributes: [NSAttributedString.Key: Any] {
        return [
            .foregroundColor: mentionColor,
            .font: textFont
        ]
    }
    
    func processPayload(with mentions: [MentionInfo]?,
                        in text: String?) -> PayloadProcessingResult {
        guard let text = text else {
            return (NSAttributedString(), nil)
        }
        let result = NSMutableAttributedString(string: text, attributes: textAttributes)
        return processPayload(with: mentions, in: result)
    }
    
    func processPayload(with mentions: [MentionInfo]?,
                        in attributedText: NSMutableAttributedString) -> PayloadProcessingResult {
        return processPayload(with: mentions, in: attributedText, mentionAttributes: mentionAttributes)
    }
}

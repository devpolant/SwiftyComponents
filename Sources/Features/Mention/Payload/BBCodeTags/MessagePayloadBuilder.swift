//
//  MessagePayloadBuilder.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

protocol MessagePayloadBuilder: class {
    func buildPayload(for text: String, with mentions: [Mention]) -> String
}

final class MessagePayloadBuilderImpl: MessagePayloadBuilder {
    
    func buildPayload(for text: String, with mentions: [Mention]) -> String {
        var result = text
        var offset = 0
        
        for mention in mentions {
            let indices = mention.indices.shifted(by: offset)
            let stringIndices = indices.stringIndices
            
            let bbTag = buildTag(for: mention)
            
            result.removeSubrange(stringIndices)
            result.insert(contentsOf: bbTag, at: stringIndices.lowerBound)
            
            offset += (bbTag.utf16.count - indices.count)
        }
        
        return result
    }
    
    private func buildTag(for mention: Mention) -> String {
        let attributes: [BBTagBuilder.Attribute] = [
            .init(name: MentionInfo.Attributes.memberId, value: String(mention.memberId)),
            .init(name: MentionInfo.Attributes.accountId, value: mention.accountId)
        ]
        return BBTagBuilder.build(tag: MentionInfo.tag, attributes: attributes, content: mention.alias)
    }
}

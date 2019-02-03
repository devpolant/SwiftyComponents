//
//  MessagePayloadParser.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

protocol MessagePayloadParser: class {
    typealias ParseResult = [MentionInfo]
    func parse(_ text: String) -> ParseResult?
}

final class MessagePayloadParserImpl: MessagePayloadParser {
    
    func parse(_ text: String) -> ParseResult? {
        return BBCodeParser.findOccurences(of: MentionInfo.self, in: text) { tag in
            guard let attributes = tag.attributes,
                let member = attributes[MentionInfo.Attributes.memberId],
                let memberId = Int64(member),
                let accountId = attributes[MentionInfo.Attributes.accountId],
                let alias = tag.text else {
                    return nil
            }
            return MentionInfo(memberId: memberId, accountId: accountId, alias: alias, range: tag.indices)
        }
    }
}

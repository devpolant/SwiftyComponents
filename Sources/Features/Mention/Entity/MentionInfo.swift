//
//  MentionInfo.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

final class MentionInfo: BBCodeEntity {
    
    static let tag = "mention"
    static let attributes = [Attributes.memberId, Attributes.accountId]
    
    enum Attributes {
        static let memberId = "memberId"
        static let accountId = "accountId"
    }
    
    let memberId: Int64
    let accountId: String
    let alias: String
    let range: Range<String.Index>
    
    init(memberId: Int64, accountId: String, alias: String, range: Range<String.Index>) {
        self.memberId = memberId
        self.accountId = accountId
        self.alias = alias
        self.range = range
    }
    
    init(mention: Mention) {
        self.memberId = mention.memberId
        self.accountId = mention.accountId
        self.alias = mention.alias
        self.range = mention.indices.stringIndices
    }
}

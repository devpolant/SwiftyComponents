//
//  Mention.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

final class Mention: CustomDebugStringConvertible {
    var indices: Range<Int>
    var memberId: Int64
    var accountId: String
    var alias: String
    
    init(indices: Range<Int>, memberId: Int64, accountId: String, alias: String) {
        self.indices = indices
        self.memberId = memberId
        self.accountId = accountId
        self.alias = alias
    }
    
    var displayString: String {
        return "@\(alias)"
    }
    
    var debugDescription: String {
        return "[Mention: displayString = '\(displayString)', indices: '\(indices)']"
    }
}

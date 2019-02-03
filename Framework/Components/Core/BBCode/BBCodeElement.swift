//
//  BBCodeElement.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

struct BBCodeElement: CustomDebugStringConvertible {
    var tag: String
    var indices: Range<String.Index>
    var text: String?
    var attributes: [String: String]?
    
    var debugDescription: String {
        return "[Element tag=\"\(tag)\", indices=\"\(indices.utf16Encoded)\", text=\"\(text ?? "")\", attributes=\"\(attributes ?? [:])\"]"
    }
}

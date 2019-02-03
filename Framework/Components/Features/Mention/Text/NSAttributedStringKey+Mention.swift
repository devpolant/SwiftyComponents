//
//  NSAttributedStringKey+Mention.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2019 Anton Poltoratskyi. All rights reserved.
//

import Foundation

public typealias TextAttributes = [NSAttributedString.Key: Any]

extension NSAttributedString.Key {
    static let mention = NSAttributedString.Key(rawValue: "mention")
}

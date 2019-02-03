//
//  Bundle.swift
//  Components
//
//  Created by Anton Poltoratskyi on 30.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

extension Bundle {
    
    /// Project bundle name
    public var bundleName: String {
        return object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String
    }
    
    /// App name which displaying in Springboard
    public var displayName: String {
        let displayName = object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        return displayName ?? self.bundleName
    }
    
    public var buildVersion: String? {
        return object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }
}

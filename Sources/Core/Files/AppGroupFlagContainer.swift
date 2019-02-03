//
//  AppGroupFlagContainer.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

class AppGroupFlagContainer {
    
    enum Flag: String {
        case shareExtension = "share-extension.lock"
        
        var fileName: String {
            return rawValue
        }
    }
    
    let fileManager: FileManager
    
    let containerURL: URL
    
    var flagsDirectoryURL: URL {
        return containerURL.appendingPathComponent("flags")
    }
    
    
    // MARK: - Init
    
    init?(fileManager: FileManager, appGroup: String) {
        self.fileManager = fileManager
        
        guard let containerURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            return nil
        }
        self.containerURL = containerURL
    }
    
    func prepare() throws {
        if !fileManager.fileExists(atPath: flagsDirectoryURL.path) {
            try fileManager.createDirectory(at: flagsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    
    // MARK: - Flags
    
    func setFlag(_ flag: Flag) throws {
        let flagURL = flagsDirectoryURL.appendingPathComponent(flag.fileName)
        
        // From Apple docs:
        // If a file already exists at path, this method overwrites the contents of that file
        // if the current process has the appropriate privileges to do so.
        fileManager.createFile(atPath: flagURL.path, contents: nil, attributes: nil)
    }
    
    func removeFlagIfExists(_ flag: Flag) throws {
        let flagURL = flagsDirectoryURL.appendingPathComponent(flag.fileName)
        guard fileManager.fileExists(atPath: flagURL.path) else {
            return
        }
        try fileManager.removeItem(atPath: flagURL.path)
    }
}

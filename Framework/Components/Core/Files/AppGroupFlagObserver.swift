//
//  AppGroupFlagObserver.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

final class AppGroupFlagObserver: AppGroupFlagContainer {
    
    private var directoryWatcher: DirectoryWatcher?
    
    
    // MARK: - Init
    
    deinit {
        stopObserving()
    }
    
    func observe(callback: @escaping ([Flag]) -> Void) throws {
        try prepare()
        
        directoryWatcher = DirectoryWatcher.makeDirectoryWatcher(withPath: flagsDirectoryURL.path) { [weak self] watcher in
            guard let self = self else {
                return
            }
            do {
                let content = try self.fileManager.contentsOfDirectory(atPath: self.flagsDirectoryURL.path)
                let flags = content.compactMap { Flag(rawValue: $0) }
                callback(flags)
            } catch { }
        }
    }
    
    func stopObserving() {
        directoryWatcher?.stop()
    }
}

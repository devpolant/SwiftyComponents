//
//  DirectoryWatcher.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

public class DirectoryWatcher {

    public typealias Callback = (DirectoryWatcher) -> Void
    
    private var directoryFileDescriptor: Int32 = -1 {
        didSet {
            if oldValue != -1 {
                close(oldValue)
            }
        }
    }
    
    private var dispatchSource: DispatchSourceFileSystemObject?
    
    private let queue: DispatchQueue
    
    
    // MARK: - Init
    
    private init(queue: DispatchQueue) {
        self.queue = queue
    }
    
    deinit {
        stop()
    }
    
    public static func makeDirectoryWatcher(withPath path: String,
                                            onQueue queue: DispatchQueue = .main,
                                            callback: @escaping Callback) -> DirectoryWatcher? {
        let directoryWatcher = DirectoryWatcher(queue: queue)
        
        if !directoryWatcher.watch(path: path, callback: callback) {
            assertionFailure()
            return nil
        }
        
        return directoryWatcher
    }
    
    
    // MARK: - Watch
    
    private func watch(path: String, callback: @escaping Callback) -> Bool {
        // Open the directory
        directoryFileDescriptor = open(path, O_EVTONLY)
        if directoryFileDescriptor < 0 {
            return false
        }
        
        // Create and configure a DispatchSource to monitor it
        let dispatchSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: directoryFileDescriptor,
                                                                       eventMask: .write,
                                                                       queue: queue)
        dispatchSource.setEventHandler { [unowned self] in
            callback(self)
        }
        dispatchSource.setCancelHandler { [unowned self] in
            self.directoryFileDescriptor = -1
        }
        self.dispatchSource = dispatchSource
        
        // Start monitoring
        dispatchSource.resume()
        
        // Success
        return true
    }
    
    public func stop() {
        // Leave if not monitoring
        guard let dispatchSource = dispatchSource else {
            return
        }
        
        // Don't listen to more events
        dispatchSource.setEventHandler(handler: nil)
        
        // Cancel the source (this will also close the directory)
        dispatchSource.cancel()
        
        dispatchSource.setCancelHandler(handler: nil)
        
        self.dispatchSource = nil
    }
}

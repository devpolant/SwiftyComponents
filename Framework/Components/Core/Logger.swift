//
//  Logger.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

enum LogTopic {
    case network
    case db
}

protocol Logger {
    typealias Topic = LogTopic
    func log(to topic: Topic, file: String, function: String, line: Int, message: String?)
}

extension Logger {
    func log(to topic: Topic, file: String = #file, function: String = #function, line: Int = #line, message: String?) {
        log(to: topic, file: file, function: function, line: line, message: message)
    }
}

//
//  User.swift
//  CellViewModelDemo
//
//  Created by Anton Poltoratskyi on 27.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

struct User {
    var name: String
}

extension User {
    static var testDataSource: [User] {
        return (1...10).map { User(name: "User #\($0)") }
    }
}

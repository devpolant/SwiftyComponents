//
//  UserTableViewCell.swift
//  CellViewModelDemo
//
//  Created by Anton Poltoratskyi on 27.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit
import Components

// MARK: - View Model

struct UserCellModel: CellViewModel {
    // Optional 'Reusable' conformance
    public static let reuseIdentifier: String = "User Cell"
    
    var user: User
    
    func setup(cell: UserTableViewCell) {
        cell.nameLabel.text = user.name
    }
}

// MARK: - Cell

final class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}

extension UserTableViewCell: XibInitializable { }

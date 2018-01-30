//
//  ViewController.swift
//  CellViewModelDemo
//
//  Created by Anton Poltoratskyi on 27.01.18.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import UIKit
import Components

class ViewController: UIViewController, KeyboardInteracting {
    var scrollView: UIScrollView!
    
    var keyboardInputViews: [KeyboardInputView]
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private var users: [AnyCellViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        users = User.testDataSource.map { UserCellModel(user: $0) }
        tableView.register(nibModel: UserCellModel.self)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withModel: tableModel(at: indexPath), for: indexPath)
    }
    
    private func tableModel(at indexPath: IndexPath) -> AnyCellViewModel {
        return users[indexPath.row]
    }
}

extension ViewController: UITableViewDelegate { }

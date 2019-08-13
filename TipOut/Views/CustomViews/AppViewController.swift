//
//  AppViewController.swift
//  TipOut
//
//  Created by Shayne Torres on 8/11/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit

class AppViewController: UIViewController {
    
    var tableView: UITableView? {
        didSet {
            guard self.tableView != nil else { return }
            
            self.registerTableViewCells()
        }
    }
    var registeredTableViewCells: [UITableViewCell.Type] {
        return [] // Implement in subclasses
    }
    
    // MARK: Table View methods
    private func registerTableViewCells() {
        for cell in self.registeredTableViewCells {
            self.tableView?.register(cell, forCellReuseIdentifier: String(describing: cell))
        }
    }
    
}

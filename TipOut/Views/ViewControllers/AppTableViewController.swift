//
//  AppTableViewController.swift
//  TipOut
//
//  Created by Shayne Torres on 9/4/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit

class AppTableViewController: UITableViewController {
    var registeredTableViewCells: [UITableViewCell.Type] {
        return [] // Implement in subclasses
    }
    var registeredTableHeaderFooterViews: [UITableViewHeaderFooterView.Type] {
        return [] // Implement in subclasses
    }
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register table view cells
        self.registerTableViewCells()
        // register table view header footer views
        self.registerTableViewHeaderFooters()
    }
    
    // MARK: Table View methods
    func registerTableViewCells() {
        for cell in self.registeredTableViewCells {
            self.tableView?.register(cell, forCellReuseIdentifier: String(describing: cell))
        }
    }
    
    func registerTableViewHeaderFooters() {
        for view in self.registeredTableHeaderFooterViews {
            self.tableView?.register(view, forHeaderFooterViewReuseIdentifier: String(describing: view))
        }
    }
}

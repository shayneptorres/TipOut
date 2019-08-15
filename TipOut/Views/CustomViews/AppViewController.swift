//
//  AppViewController.swift
//  TipOut
//
//  Created by Shayne Torres on 8/11/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit

class AppViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView? {
        didSet {
            guard self.tableView != nil else { return }
            
            self.registerTableViewCells()
        }
    }
    var registeredTableViewCells: [UITableViewCell.Type] {
        return [] // Implement in subclasses
    }
    
    // MARK: Form Modal Methods
    func showSimpleForm(labelText: String? = nil, placeholder: String? = nil, submitCompletion: ((String)->())? = nil) {
        let modalVC = ModalFormContainerViewController() // initialize the modal controller
        let simpleTextFieldViewController = SimpleTextFieldFormViewController() // initialize the simple form controller
        simpleTextFieldViewController.label = nil
        simpleTextFieldViewController.placeholder = "Enter Preset Name"
        // set the completion for when a user affirms the changes in the simple text field form vc
        simpleTextFieldViewController.submitCompletion = { name in
            modalVC.dismiss(animated: true) // dismiss the modal
            submitCompletion?(name ?? "") // call the passed in completion
        }
        modalVC.setContainer(viewController: simpleTextFieldViewController) // set the form controller on the modal vc
        modalVC.modalPresentationStyle = .overCurrentContext // we want the main view visible under the modal
        modalVC.modalTransitionStyle = .crossDissolve // we want a cross disolve appearing animation
        self.navigationController?.tabBarController?.present(modalVC, animated: true)
    }
    
    // MARK: Table View methods
    private func registerTableViewCells() {
        for cell in self.registeredTableViewCells {
            self.tableView?.register(cell, forCellReuseIdentifier: String(describing: cell))
        }
    }
    
    // sets up a tableview and its constraints for a fulls screen tableview
    func setFullScreenTableView() {
        // Setup table view
        self.tableView = UITableView()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        guard let table = self.tableView else { return }
        
        // add table view to view
        self.view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        
        // setup tableview constraints
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            table.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            table.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            table.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    // MARK: UITableViewDelegate/DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0 // override in subclass
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 // override in subclass
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell() // override in subclass
    }
}

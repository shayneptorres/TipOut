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
            
            // register table view cells
            self.registerTableViewCells()
            // register table view header footer views
            self.registerTableViewHeaderFooters()
        }
    }
    var registeredTableViewCells: [UITableViewCell.Type] {
        return [] // Implement in subclasses
    }
    var registeredTableHeaderFooterViews: [UITableViewHeaderFooterView.Type] {
        return [] // Implement in subclasses
    }
    
    // MARK: Form Modal Methods
    func showSimpleForm(title: String? = nil, labelText: String? = nil, textValue: String? = nil, placeholder: String? = nil, submitCompletion: ((ModalFormContainerViewController, String)->())? = nil) {
        let modalVC = ModalFormContainerViewController() // initialize the modal controller
        let simpleTextFieldViewController = SimpleTextFieldFormViewController() // initialize the simple form controller
        simpleTextFieldViewController.formTitle = title
        simpleTextFieldViewController.label = nil
        simpleTextFieldViewController.placeholder = "Enter Preset Name"
        simpleTextFieldViewController.textValue = textValue
        // set the completion for when a user affirms the changes in the simple text field form vc
        simpleTextFieldViewController.submitCompletion = { name in
            submitCompletion?(modalVC, name ?? "") // call the passed in completion
        }
        modalVC.setContainer(viewController: simpleTextFieldViewController) // set the form controller on the modal vc
        modalVC.modalPresentationStyle = .overCurrentContext // we want the main view visible under the modal
        modalVC.modalTransitionStyle = .crossDissolve // we want a cross disolve appearing animation
        self.navigationController?.tabBarController?.present(modalVC, animated: true)
    }
    
    func showTextNumberForm(title: String? = nil, textValue: String? = nil, textPlaceholder: String? = nil, numberValue: Double? = nil, numberPlaceholder: String? = nil, submitCompletion: ((ModalFormContainerViewController, String, Double)->())? = nil) {
        let modalVC = ModalFormContainerViewController() // initialize the modal controller
        let textNumberViewController = TextNumberFormViewController() // initialize the simple form controller
        textNumberViewController.formTitle = title
        textNumberViewController.textValue = textValue
        textNumberViewController.textFieldPlaceholder = textPlaceholder
        textNumberViewController.numberValue = numberValue
        textNumberViewController.numberTextFieldPlaceholder = numberPlaceholder
        // set the completion for when a user affirms the changes in the simple text field form vc
        textNumberViewController.submitCompletion = { text, double in
            submitCompletion?(modalVC, text, double) // call the passed in completion
        }
        modalVC.setContainer(viewController: textNumberViewController) // set the form controller on the modal vc
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
    
    private func registerTableViewHeaderFooters() {
        for view in self.registeredTableHeaderFooterViews {
            self.tableView?.register(view, forHeaderFooterViewReuseIdentifier: String(describing: view))
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

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
    
    // Form Methods
    func showTextNumberForm(title: String? = nil, textValue: String? = nil, textPlaceholder: String? = nil, numberValue: Double? = nil, numberPlaceholder: String? = nil, saleType: TipOut.SaleType = .total, submitCompletion: ((ModalFormContainerViewController, String, Double, TipOut.SaleType)->())? = nil) {
        let modalVC = ModalFormContainerViewController() // initialize the modal controller
        let textNumberViewController = TextNumberSegmentFormViewController() // initialize the simple form controller
        textNumberViewController.formTitle = title
        textNumberViewController.textValue = textValue
        textNumberViewController.textFieldPlaceholder = textPlaceholder
        textNumberViewController.numberValue = numberValue
        textNumberViewController.numberTextFieldPlaceholder = numberPlaceholder
        textNumberViewController.selectedSaleType = saleType
        // set the completion for when a user affirms the changes in the simple text field form vc
        textNumberViewController.submitCompletion = { text, double, saleType in
            submitCompletion?(modalVC, text, double, saleType) // call the passed in completion
        }
        modalVC.setContainer(viewController: textNumberViewController) // set the form controller on the modal vc
        modalVC.modalPresentationStyle = .overCurrentContext // we want the main view visible under the modal
        modalVC.modalTransitionStyle = .crossDissolve // we want a cross disolve appearing animation
        self.navigationController?.tabBarController?.present(modalVC, animated: true)
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

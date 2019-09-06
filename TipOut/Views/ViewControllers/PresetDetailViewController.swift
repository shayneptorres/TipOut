//
//  PresetDetailViewController.swift
//  TipOut
//
//  Created by Shayne Torres on 8/14/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit

class PresetDetailViewController: AppViewController, DataChangeDelegate {
    override var registeredTableViewCells: [UITableViewCell.Type] {
        return [LabelRightDetailCell.self]
    }
    override var registeredTableHeaderFooterViews: [UITableViewHeaderFooterView.Type] {
        return [LeftDetailRightDetailHeaderView.self]
    }
    var preset: TipPreset? {
        didSet {
            self.tipoutTableViewController.preset = self.preset
        }
    }
    var tipOuts: [TipOut] {
        return Array(self.preset?.tipOuts.sorted(by: { $0.createdAt < $1.createdAt }) ?? [])
    }
    let tipoutTableViewController = TipOutTableViewController()
    let tipoutContainerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the title to the name of the preset
        self.title = self.preset?.name ?? "No Name"
        // sets up the fullscreen table view
        self.view.addSubview(self.tipoutContainerView)
        self.tipoutContainerView.constrainEdgesToSuperView()
        self.tipoutContainerView.addSubview(self.tipoutTableViewController.view)
        self.tipoutTableViewController.view.constrainEdgesToSuperView()
        self.tipoutTableViewController.mode = .presetDetail
        self.addChild(self.tipoutTableViewController)
        
        // Setup nav bar buttons
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onAdd)),
            UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.onEdit))
        ]
        // begin observing
        self.setupObervers()
    }
    
    deinit {
        self.removeObservers()
    }
    
    // MARK: - Helpers
    private func updateUI() {
        // set the title to the name of the preset
        self.title = self.preset?.name ?? "No Name"
    }
    
    // MARK: - Actions
    @objc func onAdd() {
        self.showTextNumberForm(title: "Add Person", textPlaceholder: "Enter name", numberPlaceholder: "Enter tip percentage (less than 100)") { modal, name, tipPercent, saleType in
            DataManager.performChanges { context in
                guard let parentPreset = self.preset else { return }
                
                let newTipOut = TipOut.insert(into: context, name: name, tipPercentage: tipPercent, preset: parentPreset)
                self.preset?.tipOuts.insert(newTipOut)
                modal.dismiss(animated: true)
            }
        }
    }
    
    @objc func onEdit() {
        self.showSimpleForm(title: "Edit Preset Name", textValue: self.preset?.name ?? "", placeholder: "Preset name") { modal, name in
            DataManager.performChanges { context in
                self.preset?.name = name
                modal.dismiss(animated: true)
            }
        }
    }
    
    func onDidSave(_ notification: Notification) {
        self.updateUI()
        self.tipoutTableViewController.tableView.reloadData()
    }
    
    func onDidUpdate(_ notification: Notification) {
        self.updateUI()
        self.tipoutTableViewController.tableView.reloadData()
    }
}

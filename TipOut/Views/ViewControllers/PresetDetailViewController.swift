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
    var preset: TipPreset?
    var tipOuts: [TipOut] {
        return Array(self.preset?.tipOuts.sorted(by: { $0.createdAt < $1.createdAt }) ?? [])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the title to the name of the preset
        self.title = self.preset?.name ?? "No Name"
        // sets up the fullscreen table view
        self.setFullScreenTableView()
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
        self.tableView?.reloadData()
    }
    
    func onDidUpdate(_ notification: Notification) {
        self.updateUI()
        self.tableView?.reloadData()
    }
    
    // MARK: - TableView Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tipOuts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.deque(cell: LabelRightDetailCell.self, for: indexPath)
        let tipOut = self.tipOuts[indexPath.row]
        cell.textLabel?.text = tipOut.name
        let formattedPercent = String(format: "%.2f", tipOut.tipPercentage)
        cell.detailTextLabel?.text = "\(formattedPercent)%"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tipOut = self.tipOuts[indexPath.row] // grab the selected tipout
        self.showTextNumberForm(title: "Update \(tipOut.name)", textValue: tipOut.name, textPlaceholder: "Enter name", numberValue: tipOut.tipPercentage, numberPlaceholder: "Enter tip percentage (less than 100)", saleType: tipOut.saleTipType) { modal, name, tipPercent, saleType in
            DataManager.performChanges { context in
                tipOut.name = name
                tipOut.tipPercentage = tipPercent
                tipOut.saleTipType = saleType
                modal.dismiss(animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete // allow the swipe deletion of preset cells
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let tipOut = self.tipOuts[indexPath.row]
            DataManager.performChanges { context in
                tipOut.managedObjectContext?.delete(tipOut) // delete the object from the managed context
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let leftRightDetailHeader = tableView.deque(headerFooterView: LeftDetailRightDetailHeaderView.self)
        leftRightDetailHeader.leftDetailText = "Person Name"
        leftRightDetailHeader.rightDetailText = "Tip Percent (%)"
        return leftRightDetailHeader
    }
}

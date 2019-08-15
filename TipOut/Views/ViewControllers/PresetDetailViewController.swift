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
    var preset: TipPreset?
    var tipOuts: [TipOut] {
        return Array(self.preset?.tipOuts ?? [])
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
    
    // MARK: - Actions
    @objc func onAdd() {
        self.showSimpleForm(labelText: nil, placeholder: "Enter Preset Name") { name in
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let context = appDelegate.persistentContainer.viewContext // grab the app delegats persistent container
                context.performChanges {
                    guard let parentPreset = self.preset else { return }
                    
                    let newTipOut = TipOut.insert(into: context, name: name, tipPercentage: 0.0, preset: parentPreset)
                    self.preset?.tipOuts.insert(newTipOut)
                    // this performChanges block automatically calls .saveOrRollback() so we dont hve to manually do it
                }
            }
        }
    }
    
    @objc func onEdit() {
        
    }
    
    func onDidSave(_ notification: Notification) {
        self.tableView?.reloadData()
    }
    
    func onDidUpdate(_ notification: Notification) {
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
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        let formattedPercent = numberFormatter.string(from: NSNumber(value: tipOut.tipPercentage))
        cell.detailTextLabel?.text = String(describing: formattedPercent ?? "--")
        return cell
    }
    
    
    
}

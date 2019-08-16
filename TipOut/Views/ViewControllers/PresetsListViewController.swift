//
//  PresetsListViewController.swift
//  TipOut
//
//  Created by Shayne Torres on 8/11/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit
import CoreData

class PresetsListViewController: AppViewController, DataChangeDelegate {
    
    enum Mode {
        case showDetail
        case setActive
    }
    
    override var registeredTableViewCells: [UITableViewCell.Type] {
        return [LabelRightDetailCell.self]
    }
    private var presets: [TipPreset] = []
    var mode: Mode = .showDetail {
        didSet {
            
        }
    }
    private var buttonStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.loadData()
        self.setupObervers()
    }
    
    deinit {
        self.removeObservers()
    }
    
    // MARK: - Helpers
    
    private func setupViews() {
        
        // Update title
        self.title = self.mode == .showDetail ? "Presets" : "Select Active Preset"
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = System.theme.primaryBlue
        self.navigationController?.navigationBar.tintColor = System.theme.primaryWhite
        let textAttributes = [NSAttributedString.Key.foregroundColor: System.theme.primaryWhite]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        // Setup nav bar buttons
        if self.mode == .showDetail {
            // only allow the user to add preset if we are in showDetail mode
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAdd))
        }
        
        // Setup table view
        self.tableView = UITableView()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        guard let table = self.tableView else { return }
        
        // add table view to view
        self.view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        
        switch self.mode {
        case .showDetail:
            // setup tableview constraints
            NSLayoutConstraint.activate([
                table.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                table.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                table.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
                table.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                ])
        case .setActive:
//            self.view.addSubview(self.buttonStack)
//            self.buttonStack.translatesAutoresizingMaskIntoConstraints = false
            let cancelBtn = AppButton()
            cancelBtn.appButtonType = .simpleButton(textColor: .white, bgColor: .lightGray)
            self.view.addSubview(cancelBtn)
            cancelBtn.translatesAutoresizingMaskIntoConstraints = false
            cancelBtn.setTitle("Cancel", for: .normal)
            cancelBtn.addTarget(self, action: #selector(self.onCancel), for: .primaryActionTriggered)
            NSLayoutConstraint.activate([
                // set table constraints
                table.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                table.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                table.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
                // set cancel button constraints
                cancelBtn.topAnchor.constraint(equalTo: table.bottomAnchor),
                cancelBtn.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                cancelBtn.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
                cancelBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                cancelBtn.heightAnchor.constraint(equalToConstant: 45)
            ])
        }
        
    }
    
    private func loadData() {
        // grab the saved presets from the app persistent container
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.presets = TipPreset.getAll(in: appDelegate.persistentContainer.viewContext)
        }
        
        self.tableView?.reloadData()
    }
    
    func updateForMode() {
        self.loadData()
    }
    
    // MARK: - Actions
    
    @objc private func onAdd() {
        self.showSimpleForm(title: "Add Preset List", placeholder: "Enter Preset Name") { modal, name in
            DataManager.performChanges { context in
                TipPreset.insert(into: context, name: name) // perform the insert changes on the persistent container
                modal.dismiss(animated: true)
            }
        }
    }
    
    func onDidSave(_ notification: Notification) {
        self.loadData() // reload data to reflect current state
    }
    
    func onDidUpdate(_ notification: Notification) {
        self.loadData() // reload data to reflect current state
    }
    
    @objc func onCancel() {
        self.dismiss(animated: true)
    }
    
    // MARK: UITableView Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.deque(cell: LabelRightDetailCell.self, for: indexPath)
        let preset = self.presets[indexPath.row]
        cell.textLabel?.text = preset.name
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let preset = self.presets[indexPath.row]
        switch self.mode {
        case .showDetail:
            let presetDetailVC = PresetDetailViewController()
            presetDetailVC.preset = preset
            presetDetailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(presetDetailVC, animated: true)
        case .setActive:
            UserDefaultsManager.set(.activePresetID, value: String(describing: preset.id))
            self.dismiss(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // only allow the deletion of cells when mode is show detail
        return self.mode == .showDetail ? .delete : .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let preset = self.presets[indexPath.row]
            DataManager.performChanges { context in
                preset.managedObjectContext?.delete(preset) // delete the object from the managed context
            }
        default:
            break
        }
    }
}

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
    
    override var registeredTableViewCells: [UITableViewCell.Type] {
        return [LabelRightDetailCell.self]
    }
    private var presets: [TipPreset] = []
    
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
        self.title = "Presets"
        
        // Setup nav bar buttons
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAdd))
        
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
            table.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func loadData() {
        // grab the saved presets from the app persistent container
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.presets = TipPreset.getAll(in: appDelegate.persistentContainer.viewContext)
        }
        
        self.tableView?.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func onAdd() {
        self.showSimpleForm(labelText: nil, placeholder: "Enter Preset Name") { name in
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let context = appDelegate.persistentContainer.viewContext // grab the app delegats persistent container
                context.performChanges {
                    TipPreset.insert(into: context, name: name) // perform the insert changes on the persistent container
                    // this performChanges block automatically calls .saveOrRollback() so we dont hve to manually do it
                }
            }
        }
//
//        let modalVC = ModalFormContainerViewController() // initialize the modal controller
//        let simpleTextFieldViewController = SimpleTextFieldFormViewController() // initialize the simple form controller
//        simpleTextFieldViewController.label = nil
//        simpleTextFieldViewController.placeholder = "Enter Preset Name"
//        // set the completion for when a user affirms the changes in the simple text field form vc
//        simpleTextFieldViewController.submitCompletion = { name in
//            modalVC.dismiss(animated: true) // dismiss the modal
//            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//                let context = appDelegate.persistentContainer.viewContext // grab the app delegats persistent container
//                context.performChanges {
//                    TipPreset.insert(into: context, name: name ?? "No Name") // perform the insert changes on the persistent container
//                    // this performChanges block automatically calls .saveOrRollback() so we dont hve to manually do it
//                }
//            }
//        }
//        modalVC.setContainer(viewController: simpleTextFieldViewController) // set the form controller on the modal vc
//        modalVC.modalPresentationStyle = .overCurrentContext // we want the main view visible under the modal
//        modalVC.modalTransitionStyle = .crossDissolve // we want a cross disolve appearing animation
//        self.navigationController?.tabBarController?.present(modalVC, animated: true)
    }
    
    func onDidSave(_ notification: Notification) {
        self.loadData() // reload data to reflect current state
    }
    
    func onDidUpdate(_ notification: Notification) {
        self.loadData() // reload data to reflect current state
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
        let presetDetailVC = PresetDetailViewController()
        presetDetailVC.preset = self.presets[indexPath.row]
        presetDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(presetDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete // allow the swipe deletion of preset cells
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let preset = self.presets[indexPath.row]
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let context = appDelegate.persistentContainer.viewContext // grab the app delegats persistent container
                context.performChanges {
                    preset.managedObjectContext?.delete(preset) // delete the object from the managed context
                    // this performChanges block automatically calls .saveOrRollback() so we dont hve to manually do it
                }
            }
        default:
            break
        }
    }
}

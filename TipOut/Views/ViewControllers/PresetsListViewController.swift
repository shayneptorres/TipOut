//
//  PresetsListViewController.swift
//  TipOut
//
//  Created by Shayne Torres on 8/11/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit

class PresetsListViewController: AppViewController {
    
    override var registeredTableViewCells: [UITableViewCell.Type] {
        return [LabelRightDetailCell.self]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
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
        
        self.view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            table.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            table.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            table.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func onAdd() {
        let modalVC = ModalFormContainerViewController()
        let simpleTextFieldViewController = SimpleTextFieldFormViewController()
        simpleTextFieldViewController.label = nil
        simpleTextFieldViewController.placeholder = "Enter Preset Name"
        simpleTextFieldViewController.submitCompletion = { name in
            print("NAME: ", name ?? "")
            modalVC.dismiss(animated: true)
        }
        modalVC.setContainer(viewController: simpleTextFieldViewController)
        modalVC.modalPresentationStyle = .overCurrentContext
        modalVC.modalTransitionStyle = .crossDissolve
        self.navigationController?.tabBarController?.present(modalVC, animated: true, completion: {
            
        })
    }
    
}

extension PresetsListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.deque(cell: LabelRightDetailCell.self, for: indexPath)
        
        cell.textLabel?.text = "Look a cell"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

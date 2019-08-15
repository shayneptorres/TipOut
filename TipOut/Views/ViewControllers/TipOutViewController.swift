//
//  TipOutViewController.swift
//  TipOut
//
//  Created by Shayne Torres on 8/11/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit

class TipOutViewController: AppViewController {
    
    private let headerLabel = AppLabel()
    private let presetNameLabel = AppLabel()
    private let changePresetButton = AppButton()
    private let totalTextField = CurrencyTextField()
    
    override var registeredTableViewCells: [UITableViewCell.Type] {
        return [LabelRightDetailCell.self]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViews() // setup views
    }
    
    // MARK: - Helpers
    
    func setupViews() {
        // Setup header label
        self.view.addSubview(self.headerLabel)
        self.headerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.headerLabel.text = "Tip Out"
        self.headerLabel.font = AppFont.normal(font: .header)
        
        // Setup preset label
        self.view.addSubview(self.presetNameLabel)
        self.presetNameLabel.text = "Urge Gastro"
        self.presetNameLabel.font = AppFont.normal(font: .large)
        
        // Setup change preset button
        self.view.addSubview(self.changePresetButton)
        self.changePresetButton.setTitle("Change", for: .normal)
        self.changePresetButton.appButtonType = .defaultButton
        
        // Setup preset label/button stack
        let presetLabelButtonStack = UIStackView(arrangedSubviews: [self.presetNameLabel, self.changePresetButton])
        presetLabelButtonStack.axis = .horizontal
        presetLabelButtonStack.distribution = .equalCentering
        presetLabelButtonStack.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(presetLabelButtonStack)
        
        // Setup total label
        let totalLabel = AppLabel()
        totalLabel.text = "Total"
        totalLabel.font = AppFont.normal(font: .medium)
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(totalLabel)
        
        // Setup total text field
        self.totalTextField.placeholder = "ENTER TOTAL HERE"
        self.totalTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.totalTextField)
                
        // Setup tableView
        self.tableView = UITableView()
        guard let table = self.tableView else { return }
        
        self.view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        
        // Set contstrains
        NSLayoutConstraint.activate([
            // Header Label
            self.headerLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.headerLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            self.headerLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -8),
            // Preset Label
            presetLabelButtonStack.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 0),
            presetLabelButtonStack.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            presetLabelButtonStack.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -8),
            presetLabelButtonStack.heightAnchor.constraint(equalToConstant: 45),
            // Change preset button
            totalLabel.topAnchor.constraint(equalTo: presetLabelButtonStack.bottomAnchor, constant: 16),
            totalLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            totalLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -8),
            // Total TextField
            self.totalTextField.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 0),
            self.totalTextField.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            self.totalTextField.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            self.totalTextField.heightAnchor.constraint(equalToConstant: 60),
            // Table view
            table.topAnchor.constraint(equalTo: self.totalTextField.bottomAnchor, constant: 0),
            table.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            table.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            table.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func onCurrencyTFDone() {
        
    }
    
    // MARK: - UITableView Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.deque(cell: LabelRightDetailCell.self, for: indexPath)
        
        cell.textLabel?.text = "Look a cell"
        cell.detailTextLabel?.text = "And its details"
        
        return cell
    }
}

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
    private var total: Double {
        return totalTextField.doubleValue
    }
    private var preset: TipPreset? {
        didSet {
            self.updateViews()
            self.tableView?.reloadData()
        }
    }
    private var tipOuts: [TipOut] {
        return Array(self.preset?.tipOuts ?? [])
    }
    
    override var registeredTableViewCells: [UITableViewCell.Type] {
        return [LabelRightDetailCell.self]
    }
    
    override var registeredTableHeaderFooterViews: [UITableViewHeaderFooterView.Type] {
        return [LeftDetailRightDetailHeaderView.self]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViews() // setup views
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard
            let activeStrId = UserDefaultsManager.get(.activePresetID) as? String,
            let activeUUID = UUID(uuidString: activeStrId),
            let activePreset = TipPreset.getOne(with: activeUUID)
        else {
            self.preset = nil
            return
        }
        
        self.preset = activePreset
    }
    
    // MARK: - Helpers
    
    func setupViews() {
        self.view.backgroundColor = System.theme.primaryBlue
        self.tabBarController?.tabBar.barTintColor = System.theme.secondaryGray
        
        // Setup header label
        self.view.addSubview(self.headerLabel)
        self.headerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.headerLabel.text = "Tip Out"
        self.headerLabel.font = AppFont.normal(font: .header)
        self.headerLabel.textColor = System.theme.primaryWhite
        
        // Setup preset label
        self.view.addSubview(self.presetNameLabel)
        self.presetNameLabel.text = self.preset != nil ? self.preset?.name ?? "" : "No Preset Selected"
        self.presetNameLabel.font = AppFont.normal(font: .large)
        let textColor: UIColor = self.preset != nil ? .lightGray : .lightGray
        self.presetNameLabel.textColor = textColor
        
        // Setup change preset button
        self.view.addSubview(self.changePresetButton)
        let buttonTitle: String = self.preset != nil ? "Change" : "Set Preset"
        self.changePresetButton.setTitle(buttonTitle, for: .normal)
        self.changePresetButton.appButtonType = .defaultButton
        self.changePresetButton.setTitleColor(System.theme.secondaryBlue, for: .normal)
        
        // Setup preset label/button stack
        let presetLabelButtonStack = UIStackView(arrangedSubviews: [self.presetNameLabel, self.changePresetButton])
        presetLabelButtonStack.axis = .horizontal
        presetLabelButtonStack.distribution = .equalCentering
        presetLabelButtonStack.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(presetLabelButtonStack)
        self.changePresetButton.addTarget(self, action: #selector(onChangePreset), for: .primaryActionTriggered)
        
        // Setup total label
        let totalLabel = AppLabel()
        totalLabel.text = "Total"
        totalLabel.font = AppFont.normal(font: .medium)
        totalLabel.textColor = System.theme.primaryWhite
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(totalLabel)
        
        // Setup total text field
        self.totalTextField.translatesAutoresizingMaskIntoConstraints = false
        self.totalTextField.currencyDelegate = self
        self.view.addSubview(self.totalTextField)
                
        // Setup tableView
        self.tableView = UITableView(frame: .zero, style: .plain)
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
    
    // MARK: - Helpers
    func updateViews() {
        self.headerLabel.text = "Tip Out"
        self.presetNameLabel.text = self.preset != nil ? self.preset?.name ?? "" : "No Preset Selected"
        let textColor: UIColor = self.preset != nil ? .white : .white
        self.presetNameLabel.textColor = textColor
        
        // Setup change preset button
        let buttonTitle: String = self.preset != nil ? "Change" : "Set Preset"
        self.changePresetButton.setTitle(buttonTitle, for: .normal)
    }
    
    // MARK: - Actions
    
    @objc private func onCurrencyTFDone() {
        
    }
    
    @objc private func onChangePreset() {
        let presetList = PresetsListViewController()
        presetList.mode = .setActive
        let nav = UINavigationController(rootViewController: presetList)
        self.tabBarController?.present(nav, animated: true)
    }
    
    // MARK: - UITableView Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tipOuts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.deque(cell: LabelRightDetailCell.self, for: indexPath)
        let tipOut = self.tipOuts[indexPath.row]
        let tipPercent = tipOut.tipPercentage
        let tipDisplayValue = self.total * (tipPercent/100)
        cell.textLabel?.text = tipOut.name
        let formattedDollar = String(format: "%.2f", tipDisplayValue)
        let formattedPercent = String(format: "%.2f", tipOut.tipPercentage)
        cell.detailTextLabel?.text = "(\(formattedPercent)%)  $\(formattedDollar)"
        cell.detailTextLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let leftRightDetailHeader = tableView.deque(headerFooterView: LeftDetailRightDetailHeaderView.self)
        leftRightDetailHeader.leftDetailText = "Person Name"
        leftRightDetailHeader.rightDetailText = "Tip Amount ($)"
        return leftRightDetailHeader
    }
}

extension TipOutViewController: CurrencyTextFieldDelegate {
    func currencyTextFieldDidUpdate(value: Double) {
        self.tableView?.reloadData()
    }
}

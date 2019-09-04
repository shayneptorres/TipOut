//
//  TipOutViewController.swift
//  TipOut
//
//  Created by Shayne Torres on 8/11/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit

class TipOutViewController: AppViewController {
    
    enum SectionType: Int {
        case totalSales = 0
        case foodSales
        case header // make sure header is last, dont let it get confused with the enum values
    }
    private let sections: [SectionType] = [.totalSales, .foodSales]
    private let headerLabel = AppLabel()
    private let presetNameLabel = AppLabel()
    private let changePresetButton = AppButton()
    private let totalSalesTextField = CurrencyTextField()
    private let foodSalesTextField = CurrencyTextField()
    private var totalSales: Double {
        return self.totalSalesTextField.doubleValue
    }
    private var foodSales: Double {
        return self.foodSalesTextField.doubleValue
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
    private var totalTipouts: [TipOut] {
        return self.tipOuts.filter { TipOut.SaleTipType(rawValue: $0.saleTipType) == .total }
    }
    private var foodTipouts: [TipOut] {
        return self.tipOuts.filter { TipOut.SaleTipType(rawValue: $0.saleTipType) == .food }
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
        
        guard UserDefaultsManager.get(.shouldSetDefaultPresets) == nil else { return }
        
        DataManager.seedDB { preset in
            self.preset = preset
        }
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
        self.headerLabel.text = "Tip Outs"
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
        
        // Setup total sales text field
        self.totalSalesTextField.translatesAutoresizingMaskIntoConstraints = false
        self.totalSalesTextField.currencyDelegate = self
        self.totalSalesTextField.placeholder = "Enter Total Sales"
        self.view.addSubview(self.totalSalesTextField)
        
        // Setup food sales text field
        self.foodSalesTextField.translatesAutoresizingMaskIntoConstraints = false
        self.foodSalesTextField.currencyDelegate = self
        self.foodSalesTextField.placeholder = "Enter Food Sales"
        self.view.addSubview(self.foodSalesTextField)
                
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
            // Total Sales TextField
            self.totalSalesTextField.topAnchor.constraint(equalTo: presetLabelButtonStack.bottomAnchor, constant: 0),
            self.totalSalesTextField.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            self.totalSalesTextField.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            self.totalSalesTextField.heightAnchor.constraint(equalToConstant: 45),
            // Food Sales TextField
            self.foodSalesTextField.topAnchor.constraint(equalTo: self.totalSalesTextField.bottomAnchor, constant: 0),
            self.foodSalesTextField.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            self.foodSalesTextField.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            self.foodSalesTextField.heightAnchor.constraint(equalToConstant: 45),
            // Table view
            table.topAnchor.constraint(equalTo: self.foodSalesTextField.bottomAnchor, constant: 0),
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
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = SectionType(rawValue: section) else { return 0 }
        
        switch sectionType {
        case .totalSales:
            return self.totalTipouts.count
        case .foodSales:
            return self.foodTipouts.count
        case .header:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = SectionType(rawValue: indexPath.section) else { return UITableViewCell() }
        
        let cell = tableView.deque(cell: LabelRightDetailCell.self, for: indexPath)
        var tipOut: TipOut
        var tipDisplayValue: Double = 0
        
        switch sectionType {
        case .totalSales:
            tipOut = self.totalTipouts[indexPath.row]
            let tipPercent = tipOut.tipPercentage
            tipDisplayValue = self.totalSales * (tipPercent/100)
        case .foodSales:
            tipOut = self.foodTipouts[indexPath.row]
            let tipPercent = tipOut.tipPercentage
            tipDisplayValue = self.foodSales * (tipPercent/100)
        case .header:
            return cell
        }
        
        
        cell.textLabel?.text = tipOut.name
        let formattedDollar = String(format: "%.2f", tipDisplayValue)
        let formattedPercent = String(format: "%.2f", tipOut.tipPercentage)
        cell.detailTextLabel?.text = "(\(formattedPercent)%)  $\(formattedDollar)"
        cell.detailTextLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = SectionType(rawValue: section) else { return nil }
        
        let leftRightDetailHeader = tableView.deque(headerFooterView: LeftDetailRightDetailHeaderView.self)
        
        switch sectionType {
        case .totalSales:
            leftRightDetailHeader.leftDetailText = "Total Sales Tips"
            leftRightDetailHeader.rightDetailText = nil
        case .foodSales:
            leftRightDetailHeader.leftDetailText = "Food Sales Tips"
            leftRightDetailHeader.rightDetailText = nil
        case .header:
            leftRightDetailHeader.leftDetailText = "Person Name"
            leftRightDetailHeader.rightDetailText = "Tip Amount ($)"
        }
        return leftRightDetailHeader
    }
}

extension TipOutViewController: CurrencyTextFieldDelegate {
    func currency(textField: CurrencyTextField, didUpdate value: Double) {
        self.tableView?.reloadData()
    }
}

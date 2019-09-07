//
//  TipOutTableViewController.swift
//  TipOut
//
//  Created by Shayne Torres on 9/4/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit

class TipOutTableViewController: AppTableViewController {
    enum SectionType: Int {
        case totalSales = 0
        case foodSales
        case header // make sure header is last, dont let it get confused with the enum values
    }
    enum Mode {
        case activeTipout
        case presetDetail
    }
    
    var mode: Mode = .activeTipout
    var sections: [SectionType] = [.totalSales, .foodSales]
    var preset: TipPreset? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var allTipouts: [TipOut] {
        return Array(self.preset?.tipOuts.sorted(by: { $0.createdAt < $1.createdAt }) ?? [])
    }
    var totalSalesTipouts: [TipOut] {
        return self.allTipouts.filter { TipOut.SaleType(rawValue: $0.saleTipTypeValue) == .total }
    }
    var foodTipouts: [TipOut] {
        return self.allTipouts.filter { TipOut.SaleType(rawValue: $0.saleTipTypeValue) == .food }
    }
    var totalSales: Double = 0 {
        didSet {
            self.tableView.reloadData()
        }
    }
    var foodSales: Double = 0 {
        didSet {
            self.tableView.reloadData()
        }
    }
    var shouldAllowEditing: Bool {
        guard self.preset?.isDefault == false else { return false }
        
        switch self.mode {
        case .activeTipout:
            // user is on the main active tipouts screen
            return false
        case .presetDetail:
            // user is looking at preset details
            return true
        }
    }
    
    // MARK: - TableViewCells & Views
    override var registeredTableViewCells: [UITableViewCell.Type] {
        return [LabelRightDetailCell.self]
    }
    
    override var registeredTableHeaderFooterViews: [UITableViewHeaderFooterView.Type] {
        return [LeftDetailRightDetailHeaderView.self]
    }
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - UITableView Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = SectionType(rawValue: section) else { return 0 }
        
        switch sectionType {
        case .totalSales:
            return self.totalSalesTipouts.count
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
            tipOut = self.totalSalesTipouts[indexPath.row]
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
        cell.detailTextLabel?.text = mode == .activeTipout ? "(\(formattedPercent)%)  $\(formattedDollar)" : "\(formattedPercent)%"
        cell.detailTextLabel?.textColor = .red
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = SectionType(rawValue: section) else { return nil }
        
        let leftRightDetailHeader = tableView.deque(headerFooterView: LeftDetailRightDetailHeaderView.self)
        
        switch sectionType {
        case .totalSales:
            leftRightDetailHeader.leftDetailText = "Total Sales Tips"
            leftRightDetailHeader.rightDetailText = "Tip Percent (%)"
        case .foodSales:
            leftRightDetailHeader.leftDetailText = "Food Sales Tips"
            leftRightDetailHeader.rightDetailText = "Tip Percent (%)"
        case .header:
            leftRightDetailHeader.leftDetailText = "Person Name"
            leftRightDetailHeader.rightDetailText = "Tip Percent (%)"
        }
        return leftRightDetailHeader
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.shouldAllowEditing, let sectionType = SectionType(rawValue: indexPath.section) else { return }
        
        var tipOut: TipOut
        switch sectionType {
        case .totalSales:
            tipOut = self.totalSalesTipouts[indexPath.row]
        case .foodSales:
            tipOut = self.foodTipouts[indexPath.row]
        case .header:
            return
        }
        
        self.showTextNumberForm(mode: .update, title: "Update \(tipOut.name)", textValue: tipOut.name, textPlaceholder: "Enter name", numberValue: tipOut.tipPercentage, numberPlaceholder: "Enter tip percentage (less than 100)", saleType: tipOut.saleTipType) { modal, name, tipPercent, saleType in
            DataManager.performChanges { context in
                tipOut.name = name
                tipOut.tipPercentage = tipPercent
                tipOut.saleTipType = saleType
                modal.dismiss(animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if self.shouldAllowEditing {
            return UITableViewCell.EditingStyle.delete // allow the swipe deletion of preset cells
        }
        return .none
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard self.shouldAllowEditing, let sectionType = SectionType(rawValue: indexPath.section) else { return }
    
        var tipOut: TipOut
        switch sectionType {
        case .totalSales:
            tipOut = self.totalSalesTipouts[indexPath.row]
        case .foodSales:
            tipOut = self.foodTipouts[indexPath.row]
        case .header:
            return
        }
        
        switch editingStyle {
        case .delete:
            DataManager.performChanges { context in
                tipOut.managedObjectContext?.delete(tipOut) // delete the object from the managed context
            }
        default:
            break
        }
    }
}

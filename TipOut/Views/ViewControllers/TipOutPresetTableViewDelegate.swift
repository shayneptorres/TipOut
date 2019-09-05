//
//  TipOutPresetTableViewDelegate.swift
//  TipOut
//
//  Created by Shayne Torres on 9/4/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit

class TipOutPresetTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    enum SectionType: Int {
        case totalSales = 0
        case foodSales
        case header // make sure header is last, dont let it get confused with the enum values
    }
    
    var sections: [SectionType] = []
    var allTipouts: [TipOut] = []
    var totalSalesTipouts: [TipOut] {
        
    }
    
    // MARK: - UITableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

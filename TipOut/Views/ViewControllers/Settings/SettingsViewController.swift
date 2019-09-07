//
//  SettingsViewController.swift
//  TipOut
//
//  Created by Shayne Torres on 9/5/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit

class SettingsViewController: AppViewController {
    
    struct SectionInfo {
        var sectionType: SectionType
        var rowInfos: [RowInfo]
    }
    
    struct RowInfo {
        var type: RowType
    }
    
    enum RowType {
        case disclosure(title: String)
    }
    
    enum SectionType: Int {
        case defaults = 0
        
        var headerTitle: String {
            switch self {
            case .defaults:
                return "Default Presets"
            }
        }
    }
    
    // MARK: - Properties
    override var registeredTableViewCells: [UITableViewCell.Type] {
        return [UITableViewCell.self]
    }
    override var registeredTableHeaderFooterViews: [UITableViewHeaderFooterView.Type] {
        return [LeftDetailRightDetailHeaderView.self]
    }
    var sectionInfos: [SectionInfo] = [SectionInfo(sectionType: .defaults, rowInfos: [RowInfo(type: .disclosure(title: "Default Info"))])]
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setFullScreenTableView()
        self.view.backgroundColor = .tableViewHeaderColor
        self.title = "Settings"
        self.navigationController?.navigationBar.barTintColor = .primaryBlue
        self.navigationController?.navigationBar.tintColor = .primaryWhite
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.primaryWhite]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    // MARK: - UITableViewMethods
    func cell(for rowType: RowType, in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch rowType {
        case .disclosure(let title):
            let cell = tableView.deque(cell: UITableViewCell.self, for: indexPath)
            cell.textLabel?.text = title
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionInfos.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionInfos[section].rowInfos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowType = self.sectionInfos[indexPath.section].rowInfos[indexPath.row].type
        return self.cell(for: rowType, in: tableView, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionType = SectionType(rawValue: section) else { return nil }
        
        return sectionType.headerTitle
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowType = self.sectionInfos[indexPath.section].rowInfos[indexPath.row].type
        
        switch rowType {
        case .disclosure:
            let vc = SettingsDefaultInfoViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//
//  LabelRightDetailCell.swift
//  TipOut
//
//  Created by Shayne Torres on 8/11/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit

class LabelRightDetailCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    private func commonInit() {
        self.textLabel?.font = AppFont.normal(font: .medium)
        self.detailTextLabel?.font = AppFont.normal(font: .medium)
        self.detailTextLabel?.textColor = .green // TODO: update with actual theme colors
    }
}

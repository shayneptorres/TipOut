//
//  LeftDetailRightDetailHeaderView.swift
//  TipOut
//
//  Created by Shayne Torres on 8/16/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit

class LeftDetailRightDetailHeaderView:  UITableViewHeaderFooterView {
    private let leftDetailLabel = AppLabel()
    private let rightDetailLabel = AppLabel()
    var leftDetailText: String? {
        didSet {
            self.leftDetailLabel.text = self.leftDetailText
        }
    }
    var rightDetailText: String? {
        didSet {
            self.rightDetailLabel.text = self.rightDetailText
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    private func commonInit() {
        // setup left detail
        self.addSubview(self.leftDetailLabel)
        self.leftDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // setup right detail
        self.addSubview(self.rightDetailLabel)
        self.rightDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // left detail constraints
            self.leftDetailLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.leftDetailLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            self.leftDetailLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            
            // right detail constraints
            self.rightDetailLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.rightDetailLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            self.rightDetailLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
        ])
    }
}

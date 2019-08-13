//
//  AppButton.swift
//  TipOut
//
//  Created by Shayne Torres on 8/11/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit

enum AppButtonType {
    case defaultButton
    case simpleButton(textColor: UIColor, bgColor: UIColor)
}

class AppButton: UIButton {
    
    var appButtonType: AppButtonType = .defaultButton {
        didSet {
            self.updateButtonType()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    private func commonInit() {
        self.titleLabel?.font = AppFont.bold(font: .medium)
        
    }
    
    private func updateButtonType() {
        switch self.appButtonType {
        case .defaultButton:
            self.backgroundColor = .clear
            self.setTitleColor(.blue, for: .normal)
        case .simpleButton(let textColor, let bgColor):
            self.backgroundColor = bgColor
            self.setTitleColor(textColor, for: .normal)
        }
    }
    
}

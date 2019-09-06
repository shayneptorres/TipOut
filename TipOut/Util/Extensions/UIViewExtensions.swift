//
//  UIViewExtensions.swift
//  TipOut
//
//  Created by Shayne Torres on 8/15/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit

extension UIView {
    
    func constrainEdgesToSuperView() {
        guard let container = self.superview else { return }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: container.topAnchor),
            self.leftAnchor.constraint(equalTo: container.leftAnchor),
            self.rightAnchor.constraint(equalTo: container.rightAnchor),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
    }
    
}

//
//  SimpleTextFieldFormViewController.swift
//  TipOut
//
//  Created by Shayne Torres on 8/11/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit

class SimpleTextFieldFormViewController: AppFormViewController {
    private let textFieldLabel = AppLabel()
    private let textField = AppTextField()
    var label: String? = "" {
        didSet {
            self.textFieldLabel.text = self.label
        }
    }
    
    var placeholder: String? = "" {
        didSet {
            self.textField.placeholder = self.placeholder
        }
    }
    var submitCompletion: ((String?) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
    }
    
    // MARK: - Actions
    override func onAffirm() {
        self.submitCompletion?(self.textField.text)
    }
    
    // MARK: - Helpers
    func setupViews() {
        // setup label
        self.view.addSubview(self.textFieldLabel)
        self.textFieldLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldLabel.text = self.label
        self.textFieldLabel.font = AppFont.normal(font: .medium)
        
        // setup textfield
        self.view.addSubview(self.textField)
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.placeholder = self.placeholder
        
        // setup constraints
        NSLayoutConstraint.activate([
            // textfield label
            self.textFieldLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            self.textFieldLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            self.textFieldLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -8),
            // textfield
            self.textField.topAnchor.constraint(equalTo: self.textFieldLabel.bottomAnchor, constant: 4),
            self.textField.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            self.textField.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -8),
            self.textField.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            self.textField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
}

//
//  SimpleTextFieldFormViewController.swift
//  TipOut
//
//  Created by Shayne Torres on 8/11/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit

class SimpleTextFieldFormViewController: AppFormViewController {
    private let titleLabel = AppLabel()
    private let textFieldLabel = AppLabel()
    private let textField = AppTextField()
    var textValue: String? {
        didSet {
            self.textField.text = self.textValue
        }
    }
    var formTitle: String? {
        didSet {
            self.titleLabel.text = self.formTitle
        }
    }
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.textField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    override func onAffirm() {
        self.submitCompletion?(self.textField.text)
    }
    
    // MARK: - Helpers
    func setupViews() {
        // setup form title label
        self.view.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = AppFont.normal(font: .large)
        
        // setup label
        self.view.addSubview(self.textFieldLabel)
        self.textFieldLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldLabel.text = self.label
        self.textFieldLabel.font = AppFont.normal(font: .medium)
        
        // setup textfield
        self.view.addSubview(self.textField)
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.placeholder = self.placeholder
        self.textField.clearButtonMode = .always
        
        // setup constraints
        NSLayoutConstraint.activate([
            // Title label contraints
            self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            self.titleLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            self.titleLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -8),
            // textfield label
            self.textFieldLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 8),
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

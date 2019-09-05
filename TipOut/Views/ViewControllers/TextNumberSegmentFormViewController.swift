//
//  TextNumberFormViewController.swift
//  TipOut
//
//  Created by Shayne Torres on 8/15/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit

class TextNumberSegmentFormViewController: AppFormViewController, UITextFieldDelegate {
    private let titleLabel = AppLabel()
    private let textField = AppTextField()
    private let numberTextField = AppTextField()
    private let salesTypeSegment = UISegmentedControl()
    var submitCompletion: ((String, Double, TipOut.SaleType) -> ())?
    var formTitle: String? {
        didSet {
            self.titleLabel.text = self.formTitle
        }
    }
    var textValue: String? {
        didSet {
            self.textField.text = self.textValue
        }
    }
    var textFieldPlaceholder: String? {
        didSet {
            self.textField.placeholder = self.textFieldPlaceholder
        }
    }
    var numberValue: Double? {
        didSet {
            self.numberTextField.text = String(self.numberValue ?? 0)
        }
    }
    var numberTextFieldPlaceholder: String? {
        didSet {
            self.numberTextField.placeholder = self.numberTextFieldPlaceholder
        }
    }
    var selectedSaleType: TipOut.SaleType? {
        didSet {
            self.salesTypeSegment.selectedSegmentIndex = self.selectedSaleType?.rawValue ?? 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.textField.becomeFirstResponder()
    }
    
    func setupViews() {
        // setup form title label
        self.view.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = AppFont.normal(font: .large)
        
        // setup textField
        self.view.addSubview(self.textField)
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.clearButtonMode = .always
        
        // setup numberTextField
        self.view.addSubview(self.numberTextField)
        self.numberTextField.translatesAutoresizingMaskIntoConstraints = false
        self.numberTextField.keyboardType = .decimalPad
        self.numberTextField.delegate = self
        self.numberTextField.clearButtonMode = .always
        
        // setup segment control
        self.view.addSubview(self.salesTypeSegment)
        self.salesTypeSegment.translatesAutoresizingMaskIntoConstraints = false
        
        for (index, type) in TipOut.SaleType.AllCases().enumerated() {
            self.salesTypeSegment.insertSegment(withTitle: type.displayName, at: index, animated: false)
        }
        
        NSLayoutConstraint.activate([
            // Title label contraints
            self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            self.titleLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            self.titleLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -8),
            // textField constraints
            self.textField.topAnchor.constraint(equalTo: self.self.titleLabel.bottomAnchor, constant: 8),
            self.textField.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            self.textField.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -8),
            self.textField.heightAnchor.constraint(equalToConstant: 45),
            // number textfield constraints
//            self.textField.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.numberTextField.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 8),
            self.numberTextField.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            self.numberTextField.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -8),
            self.numberTextField.heightAnchor.constraint(equalToConstant: 45),
            // sales type segment control
            self.salesTypeSegment.topAnchor.constraint(equalTo: self.numberTextField.bottomAnchor, constant: 8),
            self.salesTypeSegment.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            self.salesTypeSegment.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -8),
            self.salesTypeSegment.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            self.salesTypeSegment.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    override func onAffirm() {
        guard
            let text = self.textField.text,
            let number = Double(self.numberTextField.text ?? "0"),
            let saleType = TipOut.SaleType(rawValue: self.salesTypeSegment.selectedSegmentIndex)
        else { return }
        
        self.submitCompletion?(text, number, saleType)
    }
    
    // MARK: - UITextFieldDelegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.numberTextField == textField {
            // do not allow the user to input multiple decimals
            if string == "." && self.numberTextField.text?.contains(".") == true {
                return false
            }
        }
        
        return true
    }
    
}

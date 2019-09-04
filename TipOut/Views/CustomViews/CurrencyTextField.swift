//
//  CurrencyTextField.swift
//  TipOut
//
//  Created by Shayne Torres on 8/11/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit
import Foundation

protocol CurrencyTextFieldDelegate: class {
    func currency(textField: CurrencyTextField, didUpdate value: Double)
}

class CurrencyTextField: AppTextField, UITextFieldDelegate {
    
    weak var currencyDelegate: CurrencyTextFieldDelegate?
    var doubleValue: Double {
        let currentStrValue = self.text?.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "") ?? ""
        return Double(currentStrValue) ?? 0
    }
    
    override func commonInit() {
        super.commonInit()
        
        self.textAlignment = .right
        self.textColor = System.theme.seconaryGreen
        self.backgroundColor = System.theme.secondaryGray
        self.attributedPlaceholder = NSAttributedString(
            string: "Tap to enter total",
            attributes: [NSAttributedString.Key.foregroundColor: System.theme.primaryBlack])
        self.keyboardType = .numberPad
        self.delegate = self
        self.font = AppFont.normal(font: .xLarge)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let toolBar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolBar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDone))
        toolBar.setItems([flexSpace, doneButton], animated: true)
        self.inputAccessoryView = toolBar
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var currentStrValue = self.text?.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: "") ?? ""
        
        if string == "" {
            // empty strings are backspaces, delete a number
            currentStrValue = String(currentStrValue.dropLast())
        } else {
            currentStrValue += string
        }
        
        guard let currDouble = Double(currentStrValue) else { return false }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency // set the format to currency
        let num = NSNumber(value: currDouble/100) // divide by 100, so we dont deal user inputed decimals
        self.text = formatter.string(from: num)
        self.currencyDelegate?.currency(textField: self, didUpdate: self.doubleValue)
        return false
    }
    
    @objc private func onDone() {
        self.resignFirstResponder()
    }
}

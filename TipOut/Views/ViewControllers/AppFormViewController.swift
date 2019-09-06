//
//  AppFormViewController.swift
//  TipOut
//
//  Created by Shayne Torres on 8/12/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit

class AppFormViewController: AppViewController {
    enum Mode {
        case update
        case create
    }
    var mode: Mode = .create
    func onAffirm() {
        // implement in subclass
    }
}

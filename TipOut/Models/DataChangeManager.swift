//
//  DataChangeManager.swift
//  TipOut
//
//  Created by Shayne Torres on 8/13/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import Foundation

@objc protocol DataChangeDelegate {
    @objc func onDidSave(_ notification: Notification)
    @objc func onDidUpdate(_ notification: Notification)
}

extension DataChangeDelegate {
    func setupObervers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.onDidSave(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onDidUpdate(_:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
    }
}

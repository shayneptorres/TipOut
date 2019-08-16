//
//  DataManager.swift
//  TipOut
//
//  Created by Shayne Torres on 8/15/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import CoreData
import UIKit

class DataManager {
    static func performChanges(completion: ((NSManagedObjectContext)->())? = nil) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext // grab the app delegats persistent container
            context.performChanges { // this performChanges block automatically calls .saveOrRollback() so we dont hve to manually do it
                completion?(context)
            }
        }
    }
}

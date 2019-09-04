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
    
    static func seedDB(completion: ((TipPreset)->())? = nil) {
        DataManager.performChanges { context in
            // setup default servers preset
            let defaultServersPreset = TipPreset.insert(into: context, name: "Servers")
            let defaultServersTipOuts = [
                TipOut.insert(into: context, name: "HOH", tipPercentage: 2, preset: defaultServersPreset),
                TipOut.insert(into: context, name: "Bar", tipPercentage: 1.5, preset: defaultServersPreset),
                TipOut.insert(into: context, name: "Busser", tipPercentage: 2, preset: defaultServersPreset),
                TipOut.insert(into: context, name: "Food Runner", tipPercentage: 1.5, preset: defaultServersPreset),
                TipOut.insert(into: context, name: "Host", tipPercentage: 1, preset: defaultServersPreset)
            ]
            for tipout in defaultServersTipOuts {
                defaultServersPreset.tipOuts.insert(tipout)
            }
            
            let defaultBarPreset = TipPreset.insert(into: context, name: "Bar")
            let defaultBarTipOuts = [
                TipOut.insert(into: context, name: "HOH", tipPercentage: 2, preset: defaultServersPreset),
                TipOut.insert(into: context, name: "Barback", tipPercentage: 3, preset: defaultServersPreset),
                TipOut.insert(into: context, name: "Busser", tipPercentage: 2, preset: defaultServersPreset),
                TipOut.insert(into: context, name: "Food Runner", tipPercentage: 1.5, preset: defaultServersPreset),
                TipOut.insert(into: context, name: "Host", tipPercentage: 1, preset: defaultServersPreset)
            ]
            for tipout in defaultBarTipOuts {
                defaultBarPreset.tipOuts.insert(tipout)
            }
            
            UserDefaultsManager.set(.shouldSetDefaultPresets, value: false)
            UserDefaultsManager.set(.activePresetID, value: String(describing: defaultServersPreset.id))
            completion?(defaultServersPreset)
        }
    }
}

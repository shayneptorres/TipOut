//
//  TipOut.swift
//  TipOut
//
//  Created by Shayne Torres on 8/14/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import Foundation
import CoreData

final class TipOut: NSManagedObject, Managed {
    static var entityName: String { return "TipOut" }
    
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var parentPreset: TipPreset
    @NSManaged var tipPercentage: Double
    
    @discardableResult static func insert(into context: NSManagedObjectContext, name: String, tipPercentage: Double, preset: TipPreset) -> TipOut {
        let tipOut: TipOut = context.insertObject()
        tipOut.id = UUID()
        tipOut.name = name
        tipOut.tipPercentage = tipPercentage
        tipOut.parentPreset = preset
        return tipOut
    }
}

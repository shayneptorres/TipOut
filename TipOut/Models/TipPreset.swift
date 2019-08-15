//
//  TipPreset.swift
//  TipOut
//
//  Created by Shayne Torres on 8/12/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import Foundation
import CoreData

final class TipPreset: NSManagedObject, Managed {
    static var entityName: String { return "TipPreset" }
    
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var tipOuts: Set<TipOut>
    
    @discardableResult static func insert(into context: NSManagedObjectContext, name: String) -> TipPreset {
        let tipPreset: TipPreset = context.insertObject()
        tipPreset.id = UUID()
        tipPreset.name = name
        tipPreset.tipOuts = []
        return tipPreset
    }
}

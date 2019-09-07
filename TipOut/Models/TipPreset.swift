//
//  TipPreset.swift
//  TipOut
//
//  Created by Shayne Torres on 8/12/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class TipPreset: NSManagedObject, Managed {
    static var entityName: String { return "TipPreset" }
    
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var tipOuts: Set<TipOut>
    @NSManaged var createdAt: Date
    @NSManaged var isDefault: Bool
    @NSManaged var isArchived: Bool
    
    @discardableResult static func insert(into context: NSManagedObjectContext, name: String, isDefault: Bool = false) -> TipPreset {
        let tipPreset: TipPreset = context.insertObject()
        tipPreset.id = UUID()
        tipPreset.name = name
        tipPreset.tipOuts = []
        tipPreset.createdAt = Date()
        tipPreset.isDefault = isDefault
        tipPreset.isArchived = false
        return tipPreset
    }
    
    static func getDefaults() -> [TipPreset] {
        let req = request
        req.predicate = NSPredicate(format: "isDefault = %@", argumentArray: [true])
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            do {
                return try appDelegate.persistentContainer.viewContext.fetch(req)
            } catch {
                return []
            }
        }
        return []
    }
}

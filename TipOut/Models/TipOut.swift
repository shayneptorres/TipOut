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
    
    enum SaleType: Int, CaseIterable {
        case total = 0
        case food
        
        var displayName: String {
            switch self {
            case .total:
                return "Total Sales"
            case .food:
                return "Food Sales"
            }
        }
    }
    
    static var entityName: String { return "TipOut" }
    
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var parentPreset: TipPreset
    @NSManaged var tipPercentage: Double
    @NSManaged var saleTipTypeValue: Int
    @NSManaged var createdAt: Date
    
    static func unpersistedInit(name: String, tipPercent: Double, saleTipType: SaleType = .total) -> TipOut {
        let tipOut = TipOut()
        tipOut.name = name
        tipOut.tipPercentage = tipPercent
        tipOut.saleTipType = saleTipType
        return tipOut
    }
    
    var saleTipType: SaleType {
        set {
            self.saleTipTypeValue = newValue.rawValue
        }
        get {
            return SaleType(rawValue: self.saleTipTypeValue) ?? .total
        }
    }
    
    @discardableResult static func insert(into context: NSManagedObjectContext, name: String, tipType: Int64 = 0, tipPercentage: Double, preset: TipPreset) -> TipOut {
        let tipOut: TipOut = context.insertObject()
        tipOut.id = UUID()
        tipOut.name = name
        tipOut.saleTipTypeValue = Int(tipType)
        tipOut.tipPercentage = tipPercentage
        tipOut.parentPreset = preset
        tipOut.createdAt = Date()
        return tipOut
    }
}

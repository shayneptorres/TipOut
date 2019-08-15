//
//  Managed.swift
//  TipOut
//
//  Created by Shayne Torres on 8/12/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import Foundation
import CoreData

protocol Managed: class, NSFetchRequestResult {
    static var entityName: String { get }
//    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

extension Managed where Self: NSManagedObject {
    static var request: NSFetchRequest<Self> {
        return NSFetchRequest<Self>(entityName: self.entityName)
    }
    
    static func getAll(in context: NSManagedObjectContext, configurationBlock: (NSFetchRequest<Self>) -> () = { _ in }) -> [Self] {
        let req = request
        configurationBlock(req)
        
        do {
            return try context.fetch(req)
        } catch {
            return []
        }
    }
}

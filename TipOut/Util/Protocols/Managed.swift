//
//  Managed.swift
//  TipOut
//
//  Created by Shayne Torres on 8/12/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import Foundation
import CoreData
import UIKit

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
        req.predicate = NSPredicate(format: "isArchived = %@", argumentArray: [false])
        configurationBlock(req)
        
        do {
            return try context.fetch(req)
        } catch {
            return []
        }
    }
    
    static func getOne(with id: UUID, in context: NSManagedObjectContext) -> Self? {
        let req = request
        req.predicate = NSPredicate(format: "id = %@", argumentArray: [id])
        do {
            return try context.fetch(req).first
        } catch {
            return nil
        }
    }
    
    static func getOne(with id: UUID) -> Self? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate  else { return nil }
        
        let context = appDelegate.persistentContainer.viewContext
        let req = request
        req.predicate = NSPredicate(format: "id = %@", argumentArray: [id])
        do {
            return try context.fetch(req).first
        } catch {
            return nil
        }
    }
}

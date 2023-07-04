//
//  NSManageObject+.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 04.07.2023.
//

import CoreData

extension NSManagedObject {
    
    class var entityName: String {
        String(describing: self)
    }
    
    class func findFirst(predicate: NSPredicate?, in context: NSManagedObjectContext) -> Self? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        do {
            let allResults = try context.fetch(fetchRequest) as? [NSManagedObject]
            return allResults?.first as? Self
        } catch {
            return nil
        }
    }
}

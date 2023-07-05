//
//  NSManagedObjectContext+.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 03.07.2023.
//

import CoreData

extension NSManagedObjectContext {
    func saveIfNeeded() {
        guard hasChanges else { return }
        do {
            try save()
        } catch {
            AppLogger.data.error("Save Context error: \(error.localizedDescription)")
        }
    }

    func findAll<T: NSManagedObject>(predicate: NSPredicate? = nil, fetchLimit: Int? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [T] {
        let entityName = T.entityName
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        if let fetchLimit {
            fetchRequest.fetchLimit = fetchLimit
        }
        do {
            let allResults = try self.fetch(fetchRequest) as? [T]
            return allResults ?? []
        } catch {
            return []
        }
    }

    func findFirst<T: NSManagedObject>(predicate: NSPredicate? = nil) -> T? {
        findAll(predicate: predicate, fetchLimit: 1).first
    }
}

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
}

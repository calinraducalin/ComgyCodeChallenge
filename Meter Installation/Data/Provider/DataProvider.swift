//
//  DataProvider.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 03.07.2023.
//

import CoreData
import OSLog

protocol DataProviding: AnyObject {
    var logger: Logger { get }
    var client: DataClient { get }
    var viewContext: NSManagedObjectContext { get }

    func makeNewTaskContext() -> NSManagedObjectContext
    func backgroundTask(_ task: @escaping (NSManagedObjectContext) -> Void) async
}

final class DataProvider: DataProviding {
    static let shared = DataProvider()

    let client: DataClient
    var logger: Logger { AppLogger.data }
    private let inMemory: Bool

    lazy private var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MeterInstallation")

        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }

        if inMemory {
            description.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.name = "viewContext"
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        return container
    }()

    var viewContext: NSManagedObjectContext { container.viewContext }

    private init(inMemory: Bool = false, client: DataClient = URLSession.comgy) {
        self.inMemory = inMemory
        self.client = client
    }

    func makeNewTaskContext() -> NSManagedObjectContext {
        container.newBackgroundContext()
    }

    func backgroundTask(_ task: @escaping (NSManagedObjectContext) -> Void) async {
        await withCheckedContinuation { continuanion in
            container.performBackgroundTask { context in
                task(context)
                context.saveIfNeeded()
                continuanion.resume()
            }
        }
    }

}

// - Preview

extension DataProvider {
    static let preview = DataProvider(inMemory: true, client: PreviewClient())
}


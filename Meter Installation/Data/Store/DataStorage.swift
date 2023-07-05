//
//  DataStorage.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 03.07.2023.
//

import CoreData
import OSLog

protocol DataStore: AnyObject {
    var logger: Logger? { get }
    var client: DataClient { get }
    var viewContext: NSManagedObjectContext { get }

    func makeNewTaskContext() -> NSManagedObjectContext
    func backgroundTask(_ task: @escaping (NSManagedObjectContext) -> Void) async
    func resetAllData() throws
}

final class DataStorage: DataStore {
    static let shared = DataStorage()

    let logger: Logger?
    private let inMemory: Bool
    private(set) var client: DataClient

    lazy private var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MeterInstallation")

        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }

        if inMemory {
            description.url = URL(fileURLWithPath: "/dev/null")
        }

        self.loadContainer(container)

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.name = "viewContext"
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        return container
    }()

    var viewContext: NSManagedObjectContext { container.viewContext }

    private init(inMemory: Bool = false, client: DataClient = URLSession.comgy, logger: Logger? = AppLogger.data) {
        self.inMemory = inMemory
        self.client = client
        self.logger = logger
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

    func resetAllData() throws {
        guard let store = container.persistentStoreCoordinator.persistentStores.first,
              let storeURL = store.url else { return }

        let type = NSPersistentStore.StoreType(rawValue: store.type)
        try container.persistentStoreCoordinator.destroyPersistentStore(at: storeURL, type: type)
        loadContainer(container)
    }

}

private extension DataStorage {
    func loadContainer(_ container: NSPersistentContainer) {
        container.loadPersistentStores { storeDescription, error in
            if let error = error as? NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}

// - Test

extension DataStorage {
    static let test = DataStorage(inMemory: true, client: PreviewClient(), logger: nil)

    static func test(client: DataClient) -> DataStorage {
        let store = DataStorage.test
        store.client = client
        return store
    }
}


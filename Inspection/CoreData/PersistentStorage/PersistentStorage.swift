//
//  PersistentStorage.swift
//  Inspection
//
//  Created by Piyush Sinroja on 16/06/24.
//

import Foundation

import CoreData

final class PersistentStorage {

    private init(){}
    static let shared = PersistentStorage()

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "InspectionDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context = persistentContainer.viewContext
    
    // MARK: - Core Data Saving support

    func saveContext(completion: ((_ error: Error?) -> Void)? = nil) {
        if context.hasChanges {
            do {
                try context.save()
                completion?(nil)
            } catch {
                completion?(error)
            }
        }
    }

    func fetchManagedObject<T: NSManagedObject>(managedObject: T.Type) -> [T]? {
        do {
            guard let result = try PersistentStorage.shared.context.fetch(managedObject.fetchRequest()) as? [T] else {return nil

            }
            return result
        } catch let error {
            debugPrint(error)
        }
        return nil
    }

    func printDocumentDirectoryPath() {
       debugPrint(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
    }
    
    func clearDatabase() {
        guard let url = persistentContainer.persistentStoreDescriptions.first?.url else { return }
        let persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
         do {
             try persistentStoreCoordinator.destroyPersistentStore(at:url, ofType: NSSQLiteStoreType, options: nil)
             try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
         } catch {
             print("Attempted to clear persistent store: " + error.localizedDescription)
         }
    }
}

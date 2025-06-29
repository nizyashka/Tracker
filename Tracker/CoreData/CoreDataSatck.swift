//
//  CoreDataSatck.swift
//  Tracker
//
//  Created by Алексей Непряхин on 27.06.2025.
//

import Foundation
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        ScheduleValueTransformer.register()
    }
    
    func saveContext() throws {
        let context = viewContext
        if context.hasChanges {
            try context.save()
        }
    }
}

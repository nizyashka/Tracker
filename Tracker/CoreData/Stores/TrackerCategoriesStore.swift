//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Алексей Непряхин on 26.06.2025.
//

import CoreData

final class TrackerCategoriesStore {
    static let shared = TrackerCategoriesStore()
    
    let context = CoreDataStack.shared.viewContext
    
    private init() { }
    
    func getCategories() -> [TrackerCategoriesCoreData] {
        let request = NSFetchRequest<TrackerCategoriesCoreData>(entityName: "TrackerCategoriesCoreData")
        var categories: [TrackerCategoriesCoreData] = []
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("[TrackerCategoryStore] - getCategories: Error fetching categories.")
            return categories
        }
        
        return categories
    }
    
    func getCategory(by title: String) -> TrackerCategoriesCoreData? {
        let categories = getCategories()
        
        guard let category = categories.first(where: { $0.title == title }) else {
            print("[TrackerCategoriesStore] - getCategory: No category with such title.")
            return nil
        }
        
        return category
    }
    
    func addNewCategory(title: String) -> TrackerCategoriesCoreData? {
        let trackerCategoriesCoreData = TrackerCategoriesCoreData(context: context)
        trackerCategoriesCoreData.title = title
        
        do {
            try CoreDataStack.shared.saveContext()
            return trackerCategoriesCoreData
        } catch {
            print("[TrackerCategoryStore] - addNewCategory: Error saving context.")
            return nil
        }
    }
    
    func delete(tracker: Tracker) {
        guard let trackers = DataProvider.shared.fetchTrackers(),
        let tracker = trackers.first(where: { $0.id == tracker.id }) else {
            print("[TrackerCategoryStore] - delete: Error fetching trackers or categories.")
            return
        }
        
        if let records = tracker.record as? Set<TrackerRecordsCoreData> {
            for record in records {
                context.delete(record)
            }
        }
        
        context.delete(tracker)
        
        do {
            try CoreDataStack.shared.saveContext()
        } catch {
            print("[TrackerCategoryStore] - delete: Error saving context.")
        }
    }
}

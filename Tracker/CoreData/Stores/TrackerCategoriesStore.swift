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
    
    func getCategoryByIndex(index: Int) -> TrackerCategoriesCoreData {
        let categories = getCategories()
        
        return categories[index]
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
    
}

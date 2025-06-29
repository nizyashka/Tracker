//
//  TrackerStore.swift
//  Tracker
//
//  Created by Алексей Непряхин on 26.06.2025.
//

import UIKit

final class TrackersStore {
    static let shared = TrackersStore()
    
    let context = CoreDataStack.shared.viewContext
    
    private init() { }
    
    func addNewTracker(name: String, category: TrackerCategoriesCoreData, emoji: String, color: String, schedule: [String]) {
        let trackerCoreData = TrackersCoreData(context: context)
        trackerCoreData.id = UUID()
        trackerCoreData.name = name
        trackerCoreData.category = category
        trackerCoreData.emoji = emoji
        trackerCoreData.color = color
        trackerCoreData.schedule = schedule
        
        category.addToTrackers(trackerCoreData)
        do {
            try CoreDataStack.shared.saveContext()
        } catch {
            print("[TrackerStore] - addNewTracker: Error saving context.")
        }
    }
}

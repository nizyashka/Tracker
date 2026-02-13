import CoreData

final class TrackerRecordsStore {
    static let shared = TrackerRecordsStore()
    
    let context = CoreDataStack.shared.viewContext
    
    private init() { }
    
    func addTrackerRecord(tracker: TrackersCoreData, date: Date) {
        let trackerRecordsCoreData = TrackerRecordsCoreData(context: context)
        trackerRecordsCoreData.tracker = tracker
        trackerRecordsCoreData.completeTrackerDate = date
        tracker.addToRecord(trackerRecordsCoreData)
        
        do {
            try CoreDataStack.shared.saveContext()
        } catch {
            print("[TrackerRecordsStore] - addTrackerRecord: Error saving context.")
        }
    }
    
    func deleteTrackerRecord(_ record: TrackerRecordsCoreData, tracker: TrackersCoreData) {
        tracker.removeFromRecord(record)
        context.delete(record)
        
        do {
            try CoreDataStack.shared.saveContext()
        } catch {
            print("[TrackerRecordsStore] - deleteTrackerRecord: Error saving context.")
        }
    }
}

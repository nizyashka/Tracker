import CoreData

protocol DataProviderDelegate: AnyObject {
    func updateEverything(index: IndexPath)
}

final class DataProvider: NSObject {
    static let shared = DataProvider()
    
    weak var delegate: DataProviderDelegate?
    
    let trackersStore = TrackersStore.shared
    let trackerCategoriesStore = TrackerCategoriesStore.shared
    let trackerRecordsStore = TrackerRecordsStore.shared
    let context = CoreDataStack.shared.viewContext
    
    private var insertedIndex: IndexPath?
    
    var trackerCategories: [TrackerCategory] {
        return toTrackerCategory() ?? []
    }
    
    var trackerRecords: [TrackerRecord] {
        guard let trackerRecordsCoreData = fetchTrackerRecords(),
              let trackerRecords = toTrackerRecord(trackerRecordsCoreData: trackerRecordsCoreData) else {
            return []
        }
        
        return trackerRecords
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoriesCoreData> = {
        let fetchRequest = TrackerCategoriesCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoriesCoreData.title, ascending: true)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        
        return fetchedResultsController
    }()
    
    func fetchTrackerRecords() -> [TrackerRecordsCoreData]? {
        let request = NSFetchRequest<TrackerRecordsCoreData>(entityName: "TrackerRecordsCoreData")
        let trackerRecords = try? context.fetch(request)
        
        return trackerRecords
    }
    
    func fetchTrackers() -> [TrackersCoreData]? {
        let request = NSFetchRequest<TrackersCoreData>(entityName: "TrackersCoreData")
        let trackers = try? context.fetch(request)
        
        return trackers
    }
    
    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    private override init() {
        super.init()
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func object(at indexPath: IndexPath) -> TrackerCategoriesCoreData? {
        fetchedResultsController.object(at: indexPath)
    }
    
    func toTrackerCategory() -> [TrackerCategory]? {
        guard let categories = fetchedResultsController.fetchedObjects else {
            return nil
        }
        
        var categoriesTrackerCategory: [TrackerCategory] = []
        var trackersTracker: [Tracker] = []
        
        for category in categories {
            guard let trackers = category.trackers as? Set<TrackersCoreData>,
                  let categoryTitle = category.title else {
                return nil
            }
            
            for tracker in trackers {
                guard let id = tracker.id,
                      let name = tracker.name,
                      let emoji = tracker.emoji,
                      let color = tracker.color,
                      let schedule = tracker.schedule else {
                    print("[DataProvider] - toTrackerCategory: Error getting tracker info.")
                    return nil
                }
                
                let trackerTracker = Tracker(
                    id: id,
                    name: name,
                    emoji: emoji,
                    color: color,
                    schedule: schedule)
                
                trackersTracker.append(trackerTracker)
            }
            
            categoriesTrackerCategory.append(TrackerCategory(title: categoryTitle, trackers: trackersTracker))
            trackersTracker = []
        }
        
        return categoriesTrackerCategory
    }
    
    func toTrackerRecord(trackerRecordsCoreData: [TrackerRecordsCoreData]) -> [TrackerRecord]? {
        var trackerRecords: [TrackerRecord] = []
        
        for trackerRecordCoreData in trackerRecordsCoreData {
            guard let id = trackerRecordCoreData.tracker?.id,
                  let date = trackerRecordCoreData.completeTrackerDate else {
                return nil
            }
            
            let trackerRecord = TrackerRecord(completedTrackerID: id, completedTrackerDate: date)
            trackerRecords.append(trackerRecord)
        }
        
        return trackerRecords
    }
    
    func getTrackerByID(id: UUID) -> TrackersCoreData? {
        guard let categories = fetchedResultsController.fetchedObjects else {
            return nil
        }
        
        for category in categories {
            guard let trackers = category.trackers as? Set<TrackersCoreData> else {
                return nil
            }
            
            for tracker in trackers {
                if tracker.id == id {
                    return tracker
                }
            }
        }
        
        return nil
    }
    
    func getTrackerRecordByIDAndDate(id: UUID, date: Date) -> TrackerRecordsCoreData? {
        let trackerRecordsCoreData = fetchTrackerRecords()
        var trackerRecordCoreData: TrackerRecordsCoreData? = nil
        
        trackerRecordsCoreData?.forEach {
            if $0.tracker?.id == id && $0.completeTrackerDate == date {
                trackerRecordCoreData = $0
            }
        }
        
        return trackerRecordCoreData
    }
}

extension DataProvider: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndex = IndexPath()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        guard let index = insertedIndex else {
            print("No indexes")
            return
        }
        
        delegate?.updateEverything(index: index)
        insertedIndex = nil
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        guard let indexPath = newIndexPath else { fatalError() }
        insertedIndex = indexPath
    }
}

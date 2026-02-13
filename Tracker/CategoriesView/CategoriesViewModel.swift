import UIKit

enum CoreDataError: Error {
    case saveError
}

final class CategoriesViewModel {
    var trackerCategories: [TrackerCategory]? {
        let trackerCategories = getCategoriesFromCoreData()
        
        return trackerCategories
    }
    
    var selectedCategory: String?
    
    private weak var delegate: CategoriesViewModelDelegate?
    
    private let dataProvider = DataProvider.shared
    
    var categoryAdded: (() -> Void)?
    var tableView: ((UITableView, IndexPath) -> Void)?
    
    init(delegate: CategoriesViewModelDelegate) {
        self.delegate = delegate
    }
    
    func addCategory(categoryName: String) {
        let result = saveNewCategoryToCoreData(categoryName: categoryName)
        
        switch result {
        case .success(_):
            categoryAdded?()
        case .failure(_):
            print("[CategoriesViewModel] - addCategory: Error saving a category to Core Data.")
            return
        }
    }
    
    func didSelectCell(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let categories = trackerCategories else {
            print("[CategoriesViewModel] - didSelectCell: Error getting categories from Core Data.")
            return
        }
        
        let selectedCategory = categories[indexPath.row].title
        delegate?.setTrackerCategory(categoryName: selectedCategory)
        
        for visibleIndexPath in tableView.indexPathsForVisibleRows ?? [] {
            if let cell = tableView.cellForRow(at: visibleIndexPath) as? CategoryCell {
                cell.checkmarkImageView.isHidden = true
            }
        }
        
        if let selectedCell = tableView.cellForRow(at: indexPath) as? CategoryCell {
            selectedCell.checkmarkImageView.isHidden = false
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func selectCategory(tableView: UITableView) {
        guard let selectedCategory,
              let row = trackerCategories?.firstIndex(where: { $0.title == selectedCategory }) else {
            return
        }
        
        let indexPath = IndexPath(row: row, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        self.tableView?(tableView, indexPath)
    }
    
    func getCategoriesFromCoreData() -> [TrackerCategory] {
        return dataProvider.trackerCategories
    }
    
    func saveNewCategoryToCoreData(categoryName: String) -> Result<String, Error> {
        guard let category = dataProvider.trackerCategoriesStore.addNewCategory(title: categoryName) else {
            return .failure(CoreDataError.saveError)
        }
        
        return .success(categoryName)
    }
}

//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Алексей Непряхин on 07.07.2025.
//

import UIKit

final class CategoriesViewModel {
    var trackerCategories: [TrackerCategory]? {
        let model = CategoriesModel()
        let trackerCategories = model.getCategoriesFromCoreData()
        
        return trackerCategories
    }
    
    private weak var delegate: CategoriesViewModelDelegate?
    
    private let model = CategoriesModel()
    
    var categoryAdded: (() -> Void)?
    
    init(delegate: CategoriesViewModelDelegate) {
        self.delegate = delegate
    }
    
    func addCategory(categoryName: String) {
        let result = model.saveNewCategoryToCoreData(categoryName: categoryName)
        
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
}

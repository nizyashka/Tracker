//
//  CategoriesModel.swift
//  Tracker
//
//  Created by Алексей Непряхин on 07.07.2025.
//

import Foundation

enum CoreDataError: Error {
    case saveError
}

final class CategoriesModel {
    let dataProvider = DataProvider.shared
    
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

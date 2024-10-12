//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Sergey Ivanov on 11.10.2024.
//
import UIKit

class CategoryViewModel {
    
    private(set) var categories: [TrackerCategory] = [] {
        didSet {
            onCategoriesUpdated?()
        }
    }

    var onCategoriesUpdated: (() -> Void)?

    let categoryStore: TrackerCategoryStore

    init(categoryStore: TrackerCategoryStore) {
        self.categoryStore = categoryStore
    }

    func loadCategories() {
        categories = categoryStore.fetchAllCategories()
        
        if categories.isEmpty {
            print("Категории не загружены или отсутствуют")
        } else {
            print("Загружено \(categories.count) категорий")
        }
        
        onCategoriesUpdated?()
    }

    func categoryTitle(at index: Int) -> String {
        return categories[index].title
    }

    var categoriesCount: Int {
        return categories.count
    }

    func hasCategories() -> Bool {
        return !categories.isEmpty
    }
    
    func indexOfCategory(named name: String) -> Int? {
        return categories.firstIndex(where: { $0.title == name })
    }
    
    // Удаление категории по индексу
    func deleteCategory(at index: Int) {
        let categoryToDelete = categories[index]
        categoryStore.deleteCategory(categoryToDelete)
        categories.remove(at: index)
    }
}

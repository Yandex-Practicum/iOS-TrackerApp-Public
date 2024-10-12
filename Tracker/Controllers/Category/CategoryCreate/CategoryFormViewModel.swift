//
//  CategoryFormViewModel.swift
//  Tracker
//
//  Created by Sergey Ivanov on 12.10.2024.
//

import Foundation

class CategoryFormViewModel {

    var categoryTitle: String = "" {
        didSet {
            onCategoryTitleChanged?(categoryTitle)
        }
    }

    var onCategoryTitleChanged: ((String) -> Void)?

    private let categoryStore: TrackerCategoryStore

    init(categoryStore: TrackerCategoryStore) {
        self.categoryStore = categoryStore
    }

    func saveCategory() {
        guard !categoryTitle.isEmpty else {
            print("Название категории не может быть пустым")
            return
        }
        _ = categoryStore.addCategory(title: categoryTitle)
        print("Категория добавлена: \(categoryTitle)")
    }

    func updateCategory(_ category: TrackerCategory) {
        guard !categoryTitle.isEmpty else {
            print("Название категории не может быть пустым")
            return
        }
        categoryStore.updateCategory(category, with: categoryTitle)
        print("Категория обновлена: \(categoryTitle)")
    }
}

